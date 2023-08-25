#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'httparty'

#
### Global Config
#
# httptimeout => Number in seconds for HTTP Timeout. Set to ruby default of 60 seconds.
#
$httptimeout = 2

#
# Check whether a server is Responding you can set a server to
# check via http request or ping
#
# Server Options
#   name
#       => The name of the Server Status Tile to Update
#   url
#       => Website url
#
# Notes:
#   => If the server you're checking redirects (from http to https for example)
#      the check will return false
#
#   => Where the path to the health or info endpoint is more than one folder deep (eg.. /communityapi/health) we need to convert
#      to a single path string which makes these endpoints /communityapi-health and /communityapi-info. These are converted
#      back to the 'proper' URI within the health-kick proxying application.
#

# Any service which does not have a preprod instance should be placed in this list.
# As a result the out-of-date version check will not be applied to them and they will report GREEN in preprod.

def valid_json?(string)
  begin
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end
end

def get_version(version_data)
  if version_data.nil?
    return nil
  end

  # Try a top-level key called 'version'
  if version_data.key?("version")
    return version_data['version']
  end

  # Try ['healthInfo]['version']
  if version_data.key?("healthInfo")
    return version_data['healthInfo']['version']
  end

  # Try ['build']['buildNumber']
  if version_data.key?("build")
    return version_data['build']['buildNumber']
  end

  # Try ['build']['status']
  if version_data.key?("build")
    return version_data['build']['status']
  end

  # Try a top-level key called 'build_date'
  if version_data.key?("build_date")
    version_data['build_date']
  end
end

def gather_health_data(server, env)
  unless server["#{env}Url".to_sym]
    return nil
  end
  url = server["#{env}Url".to_sym] + (server[:healthPath] || '/health')
  puts "requesting #{url}..."
  begin
    server_response = HTTParty.get(url, headers: { Accept: 'application/json' }, timeout: $httptimeout)

  rescue => e
    puts "Caught #{e.inspect} whilst reading health for #{url}"
    server_response = false
  end

  status = false
  version = 'UNKNOWN'

  # Useful debugging line
  # puts "Result from health check #{url} is #{server_response}"

  if server_response
    if valid_json?(server_response.body)
      result_json = JSON.parse(server_response.body)

      status = result_json['status'] == 'UP' || result_json['status'] == 'OK' || result_json['healthy']

      if server[:versionPath]
        version_url = server["#{env}Url".to_sym] + (server[:versionPath])
        begin
          version_response = HTTParty.get(version_url, headers: { Accept: 'application/json' }, timeout: $httptimeout)

          # Useful debugging line
          # puts "Result from version check #server[:versionUrl] is #{version_response}"

          version_json = JSON.parse(version_response.body)
          version = get_version(version_json['build'])
        rescue => e
          puts "Caught #{e.inspect} whilst reading version for #{version_url}"
        end
      else
        # Use the health data to gather version information too
        version = get_version(result_json)
      end
    end
    status = server_response.code == 200 && status
  end

  {
    status: status,
    api: {
      VERSION: status
    },
    checks: {
      VERSION: version
    },
    url: url,
  }

end

def add_outofdate(version, check_version)
  if version == check_version or !check_version
    { outofdate: 0 }
  else
    begin
      version_as_date = Date.parse(version[0..10])
      check_version_as_date = Date.parse(check_version[0..10])
      days_out_of_date = (check_version_as_date - version_as_date).to_i
      { outofdate: (days_out_of_date + 3) * 8 }
    rescue
      { outofdate: 70 }
    end
  end
end

SCHEDULER.every '2m', first_in: 0 do |_job|
  Config::PROJECTS.each do |server|
    dev_result = gather_health_data(server, 'dev')
    if dev_result
      send_event("#{server[:name]}-orig-dev", result: dev_result)
      dev_version = dev_result[:checks][:VERSION]
    else
      dev_version = nil
    end
    staging_result = gather_health_data(server, 'staging')
    if staging_result
      staging_result_with_colour = staging_result.merge(add_outofdate(staging_result[:checks][:VERSION], dev_version))
      send_event("#{server[:name]}-orig-staging", result: staging_result_with_colour)
    end
    preprod_result = gather_health_data(server, 'preprod')
    if preprod_result
      preprod_result_with_colour = preprod_result.merge(add_outofdate(preprod_result[:checks][:VERSION], dev_version))
      send_event("#{server[:name]}-orig-preprod", result: preprod_result_with_colour)

      prod_result = gather_health_data(server, 'prod')
      if prod_result
        prod_result_with_colour = prod_result.merge(add_outofdate(prod_result[:checks][:VERSION], preprod_result[:checks][:VERSION]))
        send_event("#{server[:name]}-orig-prod", result: prod_result_with_colour)
      end
    end
  end
end
