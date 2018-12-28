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
#       => Either a website url or an IP address. Do not include https:// when using ping method.
#   method
#       => http
#       => ping
#
# Notes:
#   => If the server you're checking redirects (from http to https for example)
#      the check will return false
#
servers = [

    {name: 'elite2-prod',               url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/elite2api/health', method: 'http'},
    {name: 'notm-prod',                 url: 'https://health-kick.hmpps.dsd.io/https/notm.service.hmpps.dsd.io', method: 'http'},
    {name: 'omic-ui-prod',              url: 'https://health-kick.hmpps.dsd.io/https/omic.service.hmpps.dsd.io', method: 'http'},
    {name: 'keyworker-api-prod',        url: 'https://keyworker-api.service.hmpps.dsd.io/health', method: 'http'},
    {name: 'nomis-api-prod',            textOnly: true, url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/nomisapi/health', method: 'http'},
    {name: 'newnomisapi-prod',          versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/health', method: 'http'},
    {name: 'oauth2-prod',               versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/health', method: 'http'},
    {name: 'psh-prod',                  url: 'https://health-kick.hmpps.dsd.io/https/prisonstaffhub.service.hmpps.dsd.io', method: 'http'},

    {name: 'elite2-preprod',            url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/elite2api/health', method: 'http'},
    {name: 'keyworker-api-preprod',     url: 'https://keyworker-api-preprod.service.hmpps.dsd.io/health', method: 'http'},
    {name: 'notm-preprod',              url: 'https://health-kick.hmpps.dsd.io/https/notm-preprod.service.hmpps.dsd.io', method: 'http'},
    {name: 'omic-ui-preprod',           url: 'https://health-kick.hmpps.dsd.io/https/omic-preprod.service.hmpps.dsd.io', method: 'http'},
    {name: 'psh-preprod',               url: 'https://health-kick.hmpps.dsd.io/https/prisonstaffhub-preprod.service.hmpps.dsd.io', method: 'http'},
    {name: 'nomis-api-preprod',         textOnly: true, url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/nomisapi/health', method: 'http'},
    {name: 'newnomisapi-preprod',       versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/health', method: 'http'},
    {name: 'oauth2-preprod',            versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/health', method: 'http'},

    {name: 'elite2-stage',              url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/elite2api/health', method: 'http'},
    {name: 'keyworker-api-stage',       url: 'https://keyworker-api-stage.hmpps.dsd.io/health', method: 'http'},
    {name: 'notm-stage',                url: 'https://notm-stage.hmpps.dsd.io/health', method: 'http'},
    {name: 'omic-ui-stage',             url: 'https://omic-stage.hmpps.dsd.io/health', method: 'http'},
    {name: 'psh-stage',                 url: 'https://prisonstaffhub-stage.hmpps.dsd.io/health', method: 'http'},
    {name: 'nomis-api-stage',           textOnly: true, url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/nomisapi/health', method: 'http'},
    {name: 'newnomisapi-stage',         versionUrl: 'https://gateway.t2.nomis-api.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/custodyapi/health', method: 'http'},
    {name: 'oauth2-stage',              versionUrl: 'https://gateway.t2.nomis-api.hmpps.dsd.io/auth/info', url: 'https://gateway.t2.nomis-api.hmpps.dsd.io/auth/health', method: 'http'},

    {name: 'elite2-dev',                versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/health', method: 'http'},
    {name: 'keyworker-api-dev',         url: 'https://keyworker-api-dev.hmpps.dsd.io/health', method: 'http'},
    {name: 'notm-dev',                  url: 'https://notm-dev.hmpps.dsd.io/health', method: 'http'},
    {name: 'omic-ui-dev',               url: 'https://omic-dev.hmpps.dsd.io/health', method: 'http'},
    {name: 'psh-dev',                   url: 'https://prisonstaffhub-dev.hmpps.dsd.io/health', method: 'http'},
    {name: 'nomis-api-dev',             textOnly: true, url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/nomisapi/health', method: 'http'},
    {name: 'newnomisapi-dev',           versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/health', method: 'http'},
    {name: 'oauth2-dev',                versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/health', method: 'http'},
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
      server_response = HTTParty.get(server[:url], headers: { 'Accept' => 'application/json' })
    else
      server_response = HTTParty.get(server[:url], headers: { 'Accept' => 'text/html' })
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

        unless server[:versionUrl]
          version, status = checkHealth(result_json)
        else
          status = result_json['status'] == 'UP'
          version_response = HTTParty.get(server[:versionUrl], headers: { 'Accept' => 'application/json' })
          version_json = JSON.parse(version_response.body)
          version = getVersion(version_json['build'])
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
      }
    }

end

SCHEDULER.every '60s', first_in: 0 do |_job|
    servers.each do |server|
        result = gather_health_data(server)
        send_event(server[:name], result: result)
    end
end
