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
    {name: 'notm-dev', backend: true, backendOnly: false, url: 'https://notm-dev.hmpps.dsd.io/health', method: 'http'},
    {name: 'notm-stage', backend: true, backendOnly: false, url: 'https://notm-stage.hmpps.dsd.io/health', method: 'http'},
    {name: 'notm-preprod', backend: true, backendOnly: false, url: 'https://health-kick.hmpps.dsd.io/https/notm-preprod.service.hmpps.dsd.io', method: 'http'},
    {name: 'notm-prod', backend: true, backendOnly: false, url: 'https://health-kick.hmpps.dsd.io/https/notm.service.hmpps.dsd.io', method: 'http'},
    {name: 'omic-ui-dev', backend: false, backendOnly: false, url: 'https://omic-dev.hmpps.dsd.io/info', method: 'http'},
    {name: 'keyworker-srv-dev', backend: false, backendOnly: true, url: 'https://keyworker-api-dev.hmpps.dsd.io/health', method: 'http'},
]
def gather_health_data(server)
    puts "requesting #{server[:url]}..."

    server_response = HTTParty.get(server[:url], headers: { 'Accept' => 'application/json' })

    puts server_response
    puts "Result from #{server[:url]} is #{server_response}"

    api_version = nil
    result_json = JSON.parse(server_response.body)
    status = false
    ui_version = nil

    api_data = result_json['api']
    unless api_data == 'DOWN'
      ui_version = "#{result_json['version']}"
      unless ui_version.nil? || ui_version == 0
        status = true
      end

      if server[:backend]
        status = api_data['status'] == 'UP'
        health_json = api_data['healthInfo']
        unless health_json.nil?
          api_version = health_json['version']
        end
      end

      if server[:backendOnly]
        status = result_json['status'] == 'UP'
      end
    end
    {
        status: status,
        ui_version: ui_version,
        api_version: api_version
    }
end

SCHEDULER.every '60s', first_in: 0 do |_job|
    servers.each do |server|
        result = gather_health_data(server)
        send_event(server[:name], result: result)
    end
end