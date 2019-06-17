#!/usr/bin/env ruby
require 'net/http'
require 'uri'
require 'httparty'

#
### Global Config
#
# httptimeout => Number in seconds for HTTP Timeout. Set to ruby default of 60 seconds.
# ping_count => Number of pings to perform for the ping method
#
httptimeout = 60
ping_count = 10

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
prod_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/elite2api/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/elite2api/health'},
    {name: 'notm', url: 'https://health-kick.hmpps.dsd.io/https/notm.service.hmpps.dsd.io'},
    {name: 'omic-ui', url: 'https://health-kick.hmpps.dsd.io/https/omic.service.hmpps.dsd.io'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api.service.hmpps.dsd.io/info', url: 'https://keyworker-api.service.hmpps.dsd.io/health'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/health'},
    {name: 'psh', url: 'https://health-kick.hmpps.dsd.io/https/prisonstaffhub.service.hmpps.dsd.io'},
    {name: 'cat-tool', url: 'https://health-kick.hmpps.dsd.io/https/categorisation-tool.apps.cloud-platform-live-0.k8s.integration.dsd.io'},
    {name: 'whereabouts', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api.service.justice.gov.uk'},
]

preprod_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/elite2api/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/elite2api/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api-preprod.service.hmpps.dsd.io/info', url: 'https://keyworker-api-preprod.service.hmpps.dsd.io/health'},
    {name: 'notm', url: 'https://health-kick.hmpps.dsd.io/https/notm-preprod.service.hmpps.dsd.io'},
    {name: 'omic-ui', url: 'https://health-kick.hmpps.dsd.io/https/omic-preprod.service.hmpps.dsd.io'},
    {name: 'psh', url: 'https://health-kick.hmpps.dsd.io/https/prisonstaffhub-preprod.service.hmpps.dsd.io'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/health'},
    {name: 'cat-tool', url: 'https://health-kick.hmpps.dsd.io/https/categorisation-tool-preprod.apps.cloud-platform-live-0.k8s.integration.dsd.io'},
    {name: 'whereabouts', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-preprod.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-preprod.service.justice.gov.uk'},
]

stage_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.t2.nomis-api.hmpps.dsd.io/elite2api/info', url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/elite2api/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api-stage.hmpps.dsd.io/info', url: 'https://keyworker-api-stage.hmpps.dsd.io/health'},
    {name: 'notm', url: 'https://health-kick.hmpps.dsd.io/https/notm-stage.hmpps.dsd.io'},
    {name: 'omic-ui', url: 'https://health-kick.hmpps.dsd.io/https/omic-stage.hmpps.dsd.io'},
    {name: 'psh', url: 'https://health-kick.hmpps.dsd.io/https/prisonstaffhub-stage.hmpps.dsd.io'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.t2.nomis-api.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.t2.nomis-api.hmpps.dsd.io/auth/info', url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/auth/health'},
    {name: 'community-proxy', versionUrl: 'https://health-kick.hmpps.dsd.io/https/community-api-t2.hmpps.dsd.io/communityapi-info', url: 'https://health-kick.hmpps.dsd.io/https/community-api-t2.hmpps.dsd.io/communityapi-health'},
]

dev_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api-dev.hmpps.dsd.io/info', url: 'https://keyworker-api-dev.hmpps.dsd.io/health'},
    {name: 'notm', url: 'https://notm-dev.hmpps.dsd.io/health'},
    {name: 'omic-ui', url: 'https://omic-dev.hmpps.dsd.io/health'},
    {name: 'psh', url: 'https://prisonstaffhub-dev.hmpps.dsd.io/health'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/health'},
    {name: 'cat-tool', url: 'https://categorisation-tool-dev.apps.cloud-platform-live-0.k8s.integration.dsd.io/health'},
    {name: 'whereabouts', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-dev.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-dev.service.justice.gov.uk'},
]

def valid_json?(string)
  begin
    !!JSON.parse(string)
  rescue JSON::ParserError
    false
  end
end

def getVersion(version_data)
  version = nil
  unless version_data.nil?
    version = version_data['version']
    if version.nil?
      version = version_data['healthInfo']['version']
    end
  end
  version
end


def checkHealth(data)
  version = getVersion(data)
  [version, !version.nil?]
end

def gather_health_data(server)
  puts "requesting #{server[:url]}..."
  unless server[:textOnly]
    server_response = HTTParty.get(server[:url], headers: {'Accept' => 'application/json'})
  else
    server_response = HTTParty.get(server[:url], headers: {'Accept' => 'text/html'})
  end

  puts server_response
  puts "Result from #{server[:url]} is #{server_response}"

  status = false
  version = nil

  if server[:textOnly]
    status = server_response.body == 'DB Up'
    version = status ? 'UP' : 'DOWN'
  else
    if valid_json?(server_response.body)
      result_json = JSON.parse(server_response.body)

      if server[:versionUrl]
        status = result_json['status'] == 'UP'
        version_response = HTTParty.get(server[:versionUrl], headers: {Accept: 'application/json'})
        version_json = JSON.parse(version_response.body)
        version = getVersion(version_json['build'])
      else
        version, status = checkHealth(result_json)
      end
    end
  end

  {
      status: status,
      api: {
          VERSION: status
      },
      checks: {
          VERSION: version
      },
      url: server[:versionUrl] || server[:url]
  }

end

def add_outofdate(version, check_version)
  {outofdate: version != check_version}
end

SCHEDULER.every '60s', first_in: 0 do |_job|
  dev_versions = dev_servers.map do |server|
    result = gather_health_data(server)
    send_event("#{server[:name]}-dev", result: result)
    {server[:name] => result[:checks][:VERSION]}
  end.reduce Hash.new, :merge

  stage_servers.each do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], dev_versions[server[:name]]))
    send_event("#{server[:name]}-stage", result: result_with_colour)
  end

  preprod_versions = preprod_servers.map do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], dev_versions[server[:name]]))
    send_event("#{server[:name]}-preprod", result: result_with_colour)
    {server[:name] => result[:checks][:VERSION]}
  end.reduce Hash.new, :merge

  prod_servers.each do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], preprod_versions[server[:name]]))
    send_event("#{server[:name]}-prod", result: result_with_colour)
  end
end
