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
    {name: 'dps-core', url: 'https://health-kick.hmpps.dsd.io/https/digital.prison.service.justice.gov.uk'},
    {name: 'omic-ui', url: 'https://health-kick.hmpps.dsd.io/https/manage-key-workers.service.justice.gov.uk'},
    {name: 'keyworker-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/keyworker-api.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/keyworker-api.prison.service.justice.gov.uk/health'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.prod.nomis-api.service.hmpps.dsd.io/auth/health'},
    {name: 'whereabouts', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts.prison.service.justice.gov.uk'},
    {name: 'cat-tool', url: 'https://health-kick.hmpps.dsd.io/https/offender-categorisation.service.justice.gov.uk'},
    {name: 'whereabouts-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api.service.justice.gov.uk'},
    {name: 'dps-welcome', versionUrl: 'https://health-kick.hmpps.dsd.io/https/welcome.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/welcome.prison.service.justice.gov.uk'},
    {name: 'offender-case-notes', versionUrl: 'https://health-kick.hmpps.dsd.io/https/offender-case-notes.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/offender-case-notes.service.justice.gov.uk'},
    {name: 'community-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.probation.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.probation.service.justice.gov.uk/health'},
    {name: 'licences', url: 'https://health-kick.hmpps.dsd.io/https/licences.prison.service.justice.gov.uk'},
    {name: 'batchload', url: 'https://health-kick.hmpps.dsd.io/https/nomis-batchload.service.hmpps.dsd.io'},
    {name: 'pathfinder', url: 'https://health-kick.hmpps.dsd.io/https/pathfinder.service.justice.gov.uk/health'},
    {name: 'use-of-force', url: 'https://health-kick.hmpps.dsd.io/https/use-of-force.service.justice.gov.uk/health'},
    {name: 'offender-events', versionUrl: 'https://health-kick.hmpps.dsd.io/https/offender-events.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/offender-events.prison.service.justice.gov.uk'},
    {name: 'probation-teams', versionUrl: 'https://health-kick.hmpps.dsd.io/https/probation-teams.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/probation-teams.prison.service.justice.gov.uk'},
]

preprod_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/elite2api/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/elite2api/health'},
    {name: 'keyworker-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/keyworker-api-preprod.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/keyworker-api-preprod.prison.service.justice.gov.uk/health'},
    {name: 'dps-core', url: 'https://health-kick.hmpps.dsd.io/https/digital-preprod.prison.service.justice.gov.uk'},
    {name: 'omic-ui', url: 'https://health-kick.hmpps.dsd.io/https/preprod.manage-key-workers.service.justice.gov.uk'},
    {name: 'whereabouts', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-preprod.prison.service.justice.gov.uk'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/info', url: 'https://gateway.preprod.nomis-api.service.hmpps.dsd.io/auth/health'},
    {name: 'cat-tool', url: 'https://health-kick.hmpps.dsd.io/https/preprod.offender-categorisation.service.justice.gov.uk'},
    {name: 'whereabouts-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-preprod.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-preprod.service.justice.gov.uk'},
    {name: 'offender-case-notes', versionUrl: 'https://health-kick.hmpps.dsd.io/https/preprod.offender-case-notes.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/preprod.offender-case-notes.service.justice.gov.uk'},
    {name: 'licences', url: 'https://health-kick.hmpps.dsd.io/https/licences-preprod.prison.service.justice.gov.uk'},
    {name: 'batchload', url: 'https://health-kick.hmpps.dsd.io/https/nomis-batchload-preprod.service.hmpps.dsd.io'},
    {name: 'community-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.pre-prod.delius.probation.hmpps.dsd.io/info', url: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.pre-prod.delius.probation.hmpps.dsd.io/health'},
    {name: 'pathfinder', url: 'https://health-kick.hmpps.dsd.io/https/preprod.pathfinder.service.justice.gov.uk/health'},
    {name: 'use-of-force', url: 'https://health-kick.hmpps.dsd.io/https/preprod.use-of-force.service.justice.gov.uk/health'},
    {name: 'offender-events', versionUrl: 'https://health-kick.hmpps.dsd.io/https/offender-events-preprod.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/offender-events-preprod.prison.service.justice.gov.uk'},
    {name: 'case-notes-to-probation', versionUrl: 'https://health-kick.hmpps.dsd.io/https/case-notes-to-probation-preprod.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/case-notes-to-probation-preprod.prison.service.justice.gov.uk'},
    {name: 'probation-teams', versionUrl: 'https://health-kick.hmpps.dsd.io/https/probation-teams-preprod.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/probation-teams-preprod.prison.service.justice.gov.uk'},
]

dev_servers = [
    {name: 'elite2', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/elite2api/health'},
    {name: 'keyworker-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/keyworker-api-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/keyworker-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'dps-core', url: 'https://digital-dev.prison.service.justice.gov.uk/health'},
    {name: 'omic-ui', url: 'https://dev.manage-key-workers.service.justice.gov.uk/health'},
    {name: 'whereabouts', url: 'https://whereabouts-dev.prison.service.justice.gov.uk/health'},
    {name: 'nomis-api', textOnly: true, url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/nomisapi/health'},
    {name: 'newnomisapi', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/custodyapi/health'},
    {name: 'oauth2', versionUrl: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/info', url: 'https://gateway.t3.nomis-api.hmpps.dsd.io/auth/health'},
    {name: 'cat-tool', url: 'https://health-kick.hmpps.dsd.io/https/dev.offender-categorisation.service.justice.gov.uk'},
    {name: 'whereabouts-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-dev.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/whereabouts-api-dev.service.justice.gov.uk'},
    {name: 'dps-welcome', versionUrl: 'https://health-kick.hmpps.dsd.io/https/welcome-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/welcome-dev.prison.service.justice.gov.uk'},
    {name: 'offender-case-notes', versionUrl: 'https://health-kick.hmpps.dsd.io/https/dev.offender-case-notes.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/dev.offender-case-notes.service.justice.gov.uk'},
    {name: 'offender-assessments-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/dev.devtest.assessment-api.hmpps.dsd.io/info', url: 'https://health-kick.hmpps.dsd.io/https/dev.devtest.assessment-api.hmpps.dsd.io/health'},
    {name: 'sentence-planning', url: 'https://health-kick.hmpps.dsd.io/https/sentence-planning-development.apps.live-1.cloud-platform.service.justice.gov.uk/health'},
    {name: 'licences', url: 'https://health-kick.hmpps.dsd.io/https/licences-dev.prison.service.justice.gov.uk'},
    {name: 'batchload', url: 'https://health-kick.hmpps.dsd.io/https/nomis-batchload-stage.hmpps.dsd.io'},
    {name: 'community-api', versionUrl: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.test.delius.probation.hmpps.dsd.io/info', url: 'https://health-kick.hmpps.dsd.io/https/community-api-secure.test.delius.probation.hmpps.dsd.io/health'},
    {name: 'use-of-force', url: 'https://health-kick.hmpps.dsd.io/https/dev.use-of-force.service.justice.gov.uk/health'},
    {name: 'pathfinder', url: 'https://health-kick.hmpps.dsd.io/https/dev.pathfinder.service.justice.gov.uk/health'},
    {name: 'offender-events', versionUrl: 'https://health-kick.hmpps.dsd.io/https/offender-events-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/offender-events-dev.prison.service.justice.gov.uk'},
    {name: 'dps-data-compliance', versionUrl: 'https://health-kick.hmpps.dsd.io/https/prison-data-compliance-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/prison-data-compliance-dev.prison.service.justice.gov.uk/health'},
    {name: 'case-notes-to-probation', versionUrl: 'https://health-kick.hmpps.dsd.io/https/case-notes-to-probation-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/case-notes-to-probation-dev.prison.service.justice.gov.uk'},
    {name: 'probation-teams', versionUrl: 'https://health-kick.hmpps.dsd.io/https/probation-teams-dev.prison.service.justice.gov.uk/info', url: 'https://health-kick.hmpps.dsd.io/https/probation-teams-dev.prison.service.justice.gov.uk'},
]

# Any service which does not have a development instance should be placed in this list.
# As a result the out-of-date version check will not be applied for them and will report GREEN in stage.

no_dev_servers = []

# Any service which does not have a preprod instance should be placed in this list.
# As a result the out-of-date version check will not be applied to them and they will report GREEN in preprod.

no_preprod_servers = ['dps-welcome']


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

    # Try a top-level key called 'version'
    if version_data.key?("version")
      version = version_data['version']
    end

    # Try ['healthInfo]['version']
    if version.nil?
      if version_data.key?("healthInfo")
         version = version_data['healthInfo']['version']
      end
    end

    # Try ['build']['buildNumber']
    if version.nil?
      if version_data.key?("build")
        version = version_data['build']['buildNumber']
      end
    end

    # Try ['build']['status']
    if version.nil?
      if version_data.key?("build")
        version = version_data['build']['status']
      end
    end
  end

  version
end

def gather_health_data(server)
  puts "requesting #{server[:url]}..."
  begin
    if server[:textOnly]
      server_response = HTTParty.get(server[:url], headers: {Accept: 'text/html'}, timeout: 2)
    else
      server_response = HTTParty.get(server[:url], headers: {Accept: 'application/json'}, timeout: 2)
    end

  rescue => e
    puts "Caught #{e.inspect} whilst reading health for #{server[:url]}"
    server_response = false
  end

  status = false
  version = 'UNKNOWN'

  # Useful debugging line
  # puts "Result from health check #{server[:url]} is #{server_response}"

  if server_response
    if server[:textOnly]
      status = server_response.body == 'DB Up'
      version = status ? 'UP' : 'DOWN'
    else

      if valid_json?(server_response.body)
        result_json = JSON.parse(server_response.body)

        status = result_json['status'] == 'UP' || result_json['healthy']

        if server[:versionUrl]
          begin
            version_response = HTTParty.get(server[:versionUrl], headers: {Accept: 'application/json'}, timeout: 2)

            # Useful debugging line
            # puts "Result from version check #server[:versionUrl] is #{version_response}"

            version_json = JSON.parse(version_response.body)
            version = getVersion(version_json['build'])
          rescue => e
            puts "Caught #{e.inspect} whilst reading version for #{server[:versionUrl]}"
          end
        else
          # Use the health data to gather version information too
          version = getVersion(result_json)
        end
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

  preprod_versions = preprod_servers.map do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], dev_versions[server[:name]]))
    send_event("#{server[:name]}-preprod", result: result_with_colour)
    {server[:name] => result[:checks][:VERSION]}
  end.reduce Hash.new, :merge

  prod_servers.each do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], preprod_versions[server[:name]]))

    # Do not use the out-of-date warning colour for services with no pre-prod instances
    if no_preprod_servers.include?(server[:name])
       send_event("#{server[:name]}-prod", result: result)
    else
       send_event("#{server[:name]}-prod", result: result_with_colour)
    end
  end
end
