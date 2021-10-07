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
prod_servers = [
    {name: 'prison-api', versionUrl: 'https://api.prison.service.justice.gov.uk/info', url: 'https://api.prison.service.justice.gov.uk/health'},
    {name: 'dps-core', url: 'https://digital.prison.service.justice.gov.uk/health'},
    {name: 'manage-key-workers', url: 'https://manage-key-workers.service.justice.gov.uk/health'},
    {name: 'manage-hmpps-auth-accounts', url: 'https://manage-hmpps-auth-accounts.prison.service.justice.gov.uk/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api.prison.service.justice.gov.uk/info', url: 'https://keyworker-api.prison.service.justice.gov.uk/health'},
    {name: 'oauth2', versionUrl: 'https://sign-in.hmpps.service.justice.gov.uk/auth/info', url: 'https://sign-in.hmpps.service.justice.gov.uk/auth/health'},
    {name: 'offender-categorisation', url: 'https://health-kick.prison.service.justice.gov.uk/https/offender-categorisation.service.justice.gov.uk'},
    {name: 'whereabouts-api', versionUrl: 'https://whereabouts-api.service.justice.gov.uk/info', url: 'https://whereabouts-api.service.justice.gov.uk/health'},
    {name: 'offender-case-notes', versionUrl: 'https://offender-case-notes.service.justice.gov.uk/info', url: 'https://offender-case-notes.service.justice.gov.uk/health'},
    {name: 'community-api', versionUrl: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.probation.service.justice.gov.uk/info', url: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.probation.service.justice.gov.uk/health'},
    {name: 'licences', url: 'https://licences.prison.service.justice.gov.uk/health'},
    {name: 'pathfinder', url: 'https://health-kick.prison.service.justice.gov.uk/https/pathfinder.service.justice.gov.uk/health'},
    {name: 'use-of-force', url: 'https://use-of-force.service.justice.gov.uk/health'},
    {name: 'prison-offender-events', versionUrl: 'https://offender-events.prison.service.justice.gov.uk/info', url: 'https://offender-events.prison.service.justice.gov.uk/health'},
    {name: 'case-notes-to-probation', versionUrl: 'https://health-kick.prison.service.justice.gov.uk/https/case-notes-to-probation.prison.service.justice.gov.uk/info', url: 'https://health-kick.prison.service.justice.gov.uk/https/case-notes-to-probation.prison.service.justice.gov.uk'},
    {name: 'probation-teams', versionUrl: 'https://probation-teams.prison.service.justice.gov.uk/info', url: 'https://probation-teams.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-probation-update', versionUrl: 'https://prison-to-probation-update.prison.service.justice.gov.uk/info', url: 'https://prison-to-probation-update.prison.service.justice.gov.uk/health'},
    {name: 'dps-data-compliance', versionUrl: 'https://prison-data-compliance.prison.service.justice.gov.uk/info', url: 'https://prison-data-compliance.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-search', versionUrl: 'https://probation-offender-search.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-search.hmpps.service.justice.gov.uk/health'},
    {name: 'check-my-diary', url: 'https://checkmydiary.service.justice.gov.uk/health'},
    {name: 'token-verification-api', versionUrl: 'https://token-verification-api.prison.service.justice.gov.uk/info', url: 'https://token-verification-api.prison.service.justice.gov.uk/health'},
    {name: 'prisoner-offender-search', versionUrl: 'https://prisoner-offender-search.prison.service.justice.gov.uk/info', url: 'https://prisoner-offender-search.prison.service.justice.gov.uk/health'},
    {name: 'pathfinder-api', versionUrl: 'https://api.pathfinder.service.justice.gov.uk/info', url: 'https://api.pathfinder.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases', url: 'https://manage-soc-cases.hmpps.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases-api', versionUrl: 'https://manage-soc-cases-api.hmpps.service.justice.gov.uk/info', url: 'https://manage-soc-cases-api.hmpps.service.justice.gov.uk/health'},
    {name: 'probation-offender-search-indexer', versionUrl: 'https://probation-search-indexer.hmpps.service.justice.gov.uk/info', url: 'https://probation-search-indexer.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor', url: 'https://pin-phone-monitor.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor-api', versionUrl: 'https://pin-phone-monitor-api.prison.service.justice.gov.uk/info', url: 'https://pin-phone-monitor-api.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-events', versionUrl: 'https://probation-offender-events.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-events.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-services-feedback-and-support', url: 'https://support.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-book-video-link', url: 'https://book-video-link.prison.service.justice.gov.uk/health'},
    {name: 'court-register', versionUrl: 'https://court-register.hmpps.service.justice.gov.uk/info', url: 'https://court-register.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-register', versionUrl: 'https://prison-register.hmpps.service.justice.gov.uk/info', url: 'https://prison-register.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-audit-api', versionUrl: 'https://audit-api.hmpps.service.justice.gov.uk/info', url: 'https://audit-api.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers', url: 'https://registers.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-delius-update', versionUrl: 'https://registers-to-delius-update.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-delius-update.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-nomis-update', versionUrl: 'https://registers-to-nomis-update.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-nomis-update.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-book-secure-move-frontend', url: 'https://bookasecuremove.service.justice.gov.uk/healthcheck'},
    {name: 'hmpps-book-secure-move-api', url: 'https://api.bookasecuremove.service.justice.gov.uk/health'},
    {name: 'calculate-journey-variable-payments', versionUrl: 'https://calculate-journey-variable-payments.hmpps.service.justice.gov.uk/info', url: 'https://calculate-journey-variable-payments.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients', url: 'https://manage-restricted-patients.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients-api', versionUrl: 'https://restricted-patients-api.hmpps.service.justice.gov.uk/info', url: 'https://restricted-patients-api.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-welcome-people-into-prison-api', versionUrl: 'https://welcome-api.prison.service.justice.gov.uk/info', url: 'https://welcome-api.prison.service.justice.gov.uk/health' },
    {name: 'hmpps-welcome-people-into-prison-ui', url: 'https://welcome.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-nhs-update', versionUrl: 'https://prison-to-nhs-update-dev.prison.service.justice.gov.uk/info', url: 'https://prison-to-nhs-update-dev.prison.service.justice.gov.uk/health'},
    {name: 'nomis-user-roles-api', versionUrl: 'https://nomis-user.aks-live-1.studio-hosting.service.justice.gov.uk/info', url: 'https://nomis-user.aks-live-1.studio-hosting.service.justice.gov.uk/health'},
    {name: 'hmpps-manage-users-api', versionUrl: 'https://hmpps-manage-users-api.hmpps.service.justice.gov.uk/info', url: 'https://hmpps-manage-users-api.hmpps.service.justice.gov.uk/health'},
]

preprod_servers = [
    {name: 'prison-api', versionUrl: 'https://api-preprod.prison.service.justice.gov.uk/info', url: 'https://api-preprod.prison.service.justice.gov.uk/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api-preprod.prison.service.justice.gov.uk/info', url: 'https://keyworker-api-preprod.prison.service.justice.gov.uk/health'},
    {name: 'dps-core', url: 'https://digital-preprod.prison.service.justice.gov.uk/health'},
    {name: 'manage-key-workers', url: 'https://preprod.manage-key-workers.service.justice.gov.uk/health'},
    {name: 'manage-hmpps-auth-accounts', url: 'https://manage-hmpps-auth-accounts-preprod.prison.service.justice.gov.uk/health'},
    {name: 'oauth2', versionUrl: 'https://sign-in-preprod.hmpps.service.justice.gov.uk/auth/info', url: 'https://sign-in-preprod.hmpps.service.justice.gov.uk/auth/health'},
    {name: 'offender-categorisation', url: 'https://health-kick.prison.service.justice.gov.uk/https/preprod.offender-categorisation.service.justice.gov.uk'},
    {name: 'whereabouts-api', versionUrl: 'https://whereabouts-api-preprod.service.justice.gov.uk/info', url: 'https://whereabouts-api-preprod.service.justice.gov.uk/health'},
    {name: 'offender-case-notes', versionUrl: 'https://preprod.offender-case-notes.service.justice.gov.uk/info', url: 'https://preprod.offender-case-notes.service.justice.gov.uk/health'},
    {name: 'licences', url: 'https://licences-preprod.prison.service.justice.gov.uk/health'},
    {name: 'community-api', versionUrl: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.pre-prod.delius.probation.hmpps.dsd.io/info', url: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.pre-prod.delius.probation.hmpps.dsd.io/health'},
    {name: 'pathfinder', url: 'https://health-kick.prison.service.justice.gov.uk/https/preprod.pathfinder.service.justice.gov.uk/health'},
    {name: 'use-of-force', url: 'https://preprod.use-of-force.service.justice.gov.uk/health'},
    {name: 'prison-offender-events', versionUrl: 'https://offender-events-preprod.prison.service.justice.gov.uk/info', url: 'https://offender-events-preprod.prison.service.justice.gov.uk/health'},
    {name: 'case-notes-to-probation', versionUrl: 'https://health-kick.prison.service.justice.gov.uk/https/case-notes-to-probation-preprod.prison.service.justice.gov.uk/info', url: 'https://health-kick.prison.service.justice.gov.uk/https/case-notes-to-probation-preprod.prison.service.justice.gov.uk'},
    {name: 'probation-teams', versionUrl: 'https://probation-teams-preprod.prison.service.justice.gov.uk/info', url: 'https://probation-teams-preprod.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-probation-update', versionUrl: 'https://prison-to-probation-update-preprod.prison.service.justice.gov.uk/info', url: 'https://prison-to-probation-update-preprod.prison.service.justice.gov.uk/health'},
    {name: 'dps-data-compliance', versionUrl: 'https://prison-data-compliance-preprod.prison.service.justice.gov.uk/info', url: 'https://prison-data-compliance-preprod.prison.service.justice.gov.uk/health'},
    {name: 'check-my-diary', url: 'https://check-my-diary-preprod.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-search', versionUrl: 'https://probation-offender-search-preprod.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-search-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'token-verification-api', versionUrl: 'https://token-verification-api-preprod.prison.service.justice.gov.uk/info', url: 'https://token-verification-api-preprod.prison.service.justice.gov.uk/health'},
    {name: 'prisoner-offender-search', versionUrl: 'https://prisoner-offender-search-preprod.prison.service.justice.gov.uk/info', url: 'https://prisoner-offender-search-preprod.prison.service.justice.gov.uk/health'},
    {name: 'pathfinder-api', versionUrl: 'https://preprod-api.pathfinder.service.justice.gov.uk/info', url: 'https://preprod-api.pathfinder.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases', url: 'https://manage-soc-cases-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases-api', versionUrl: 'https://manage-soc-cases-api-preprod.hmpps.service.justice.gov.uk/info', url: 'https://manage-soc-cases-api-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'probation-offender-search-indexer', versionUrl: 'https://probation-search-indexer-preprod.hmpps.service.justice.gov.uk/info', url: 'https://probation-search-indexer-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor', url: 'https://pin-phone-monitor-qa.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor-api', versionUrl: 'https://pin-phone-monitor-api-qa.prison.service.justice.gov.uk/info', url: 'https://pin-phone-monitor-api-qa.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-events', versionUrl: 'https://probation-offender-events-preprod.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-events-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-services-feedback-and-support', url: 'https://support-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-book-video-link', url: 'https://book-video-link-preprod.prison.service.justice.gov.uk/health'},
    {name: 'court-register', versionUrl: 'https://court-register-preprod.hmpps.service.justice.gov.uk/info', url: 'https://court-register-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-register', versionUrl: 'https://prison-register-preprod.hmpps.service.justice.gov.uk/info', url: 'https://prison-register-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-audit-api', versionUrl: 'https://audit-api-preprod.hmpps.service.justice.gov.uk/info', url: 'https://audit-api-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers', url: 'https://registers-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-delius-update', versionUrl: 'https://registers-to-delius-update-preprod.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-delius-update-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-nomis-update', versionUrl: 'https://registers-to-nomis-update-preprod.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-nomis-update-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-book-secure-move-frontend', url: 'https://hmpps-book-secure-move-frontend-preprod.apps.live-1.cloud-platform.service.justice.gov.uk/healthcheck'},
    {name: 'hmpps-book-secure-move-api', url: 'https://hmpps-book-secure-move-api-preprod.apps.live-1.cloud-platform.service.justice.gov.uk/health'},
    {name: 'calculate-journey-variable-payments', versionUrl: 'https://calculate-journey-variable-payments-preprod.apps.live-1.cloud-platform.service.justice.gov.uk/info', url: 'https://calculate-journey-variable-payments-preprod.apps.live-1.cloud-platform.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients', url: 'https://manage-restricted-patients-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients-api', versionUrl: 'https://restricted-patients-api-preprod.hmpps.service.justice.gov.uk/info', url: 'https://restricted-patients-api-preprod.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-welcome-people-into-prison-api', versionUrl: 'https://welcome-api-preprod.prison.service.justice.gov.uk/info', url: 'https://welcome-api-preprod.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-welcome-people-into-prison-ui', url: 'https://welcome-preprod.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-nhs-update', versionUrl: 'https://prison-to-nhs-update-preprod.prison.service.justice.gov.uk/info', url: 'https://prison-to-nhs-update-preprod.prison.service.justice.gov.uk/health'},
    {name: 'nomis-user-roles-api', versionUrl: 'https://nomis-user-pp.aks-live-1.studio-hosting.service.justice.gov.uk/info', url: 'https://nomis-user-pp.aks-live-1.studio-hosting.service.justice.gov.uk/health'},
    {name: 'hmpps-manage-users-api', versionUrl: 'https://hmpps-manage-users-api-preprod.hmpps.service.justice.gov.uk/info', url: 'https://hmpps-manage-users-api-preprod.hmpps.service.justice.gov.uk/health'},
]

staging_servers = [
    {name: 'community-api', versionUrl: 'https://community-api.stage.probation.service.justice.gov.uk/info', url: 'https://community-api.stage.probation.service.justice.gov.uk/health'},
    {name: 'probation-offender-search', versionUrl: 'https://probation-offender-search-staging.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-search-staging.hmpps.service.justice.gov.uk/health'},
    {name: 'probation-offender-search-indexer', versionUrl: 'https://probation-search-indexer-staging.hmpps.service.justice.gov.uk/info', url: 'https://probation-search-indexer-staging.hmpps.service.justice.gov.uk/health'},
    {name: 'probation-offender-events', versionUrl: 'https://probation-offender-events-staging.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-events-staging.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-book-secure-move-frontend', url: 'https://hmpps-book-secure-move-frontend-staging.apps.live-1.cloud-platform.service.justice.gov.uk/healthcheck'},
    {name: 'hmpps-book-secure-move-api', url: 'https://hmpps-book-secure-move-api-staging.apps.live-1.cloud-platform.service.justice.gov.uk/health'},
]

dev_servers = [
    {name: 'prison-api', versionUrl: 'https://api-dev.prison.service.justice.gov.uk/info', url: 'https://api-dev.prison.service.justice.gov.uk/health'},
    {name: 'keyworker-api', versionUrl: 'https://keyworker-api-dev.prison.service.justice.gov.uk/info', url: 'https://keyworker-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'dps-core', url: 'https://digital-dev.prison.service.justice.gov.uk/health'},
    {name: 'manage-key-workers', url: 'https://dev.manage-key-workers.service.justice.gov.uk/health'},
    {name: 'manage-hmpps-auth-accounts', url: 'https://manage-hmpps-auth-accounts-dev.prison.service.justice.gov.uk/health'},
    {name: 'oauth2', versionUrl: 'https://sign-in-dev.hmpps.service.justice.gov.uk/auth/info', url: 'https://sign-in-dev.hmpps.service.justice.gov.uk/auth/health'},
    {name: 'offender-categorisation', url: 'https://dev.offender-categorisation.service.justice.gov.uk/health'},
    {name: 'whereabouts-api', versionUrl: 'https://whereabouts-api-dev.service.justice.gov.uk/info', url: 'https://whereabouts-api-dev.service.justice.gov.uk/health'},
    {name: 'offender-case-notes', versionUrl: 'https://dev.offender-case-notes.service.justice.gov.uk/info', url: 'https://dev.offender-case-notes.service.justice.gov.uk/health'},
    {name: 'offender-assessments-api', versionUrl: 'https://dev.devtest.assessment-api.hmpps.dsd.io/info', url: 'https://dev.devtest.assessment-api.hmpps.dsd.io/health'},
    {name: 'licences', url: 'https://licences-dev.prison.service.justice.gov.uk/health'},
    {name: 'community-api', versionUrl: 'https://community-api.test.probation.service.justice.gov.uk/info', url: 'https://community-api.test.probation.service.justice.gov.uk/health'},
    {name: 'use-of-force', url: 'https://dev.use-of-force.service.justice.gov.uk/health'},
    {name: 'pathfinder', url: 'https://dev.pathfinder.service.justice.gov.uk/health'},
    {name: 'prison-offender-events', versionUrl: 'https://offender-events-dev.prison.service.justice.gov.uk/info', url: 'https://offender-events-dev.prison.service.justice.gov.uk/health'},
    {name: 'dps-data-compliance', versionUrl: 'https://prison-data-compliance-dev.prison.service.justice.gov.uk/info', url: 'https://prison-data-compliance-dev.prison.service.justice.gov.uk/health'},
    {name: 'case-notes-to-probation', versionUrl: 'https://case-notes-to-probation-dev.prison.service.justice.gov.uk/info', url: 'https://case-notes-to-probation-dev.prison.service.justice.gov.uk/health'},
    {name: 'probation-teams', versionUrl: 'https://probation-teams-dev.prison.service.justice.gov.uk/info', url: 'https://probation-teams-dev.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-probation-update', versionUrl: 'https://prison-to-probation-update-dev.prison.service.justice.gov.uk/info', url: 'https://prison-to-probation-update-dev.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-search', versionUrl: 'https://probation-offender-search-dev.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-search-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'check-my-diary', url: 'https://check-my-diary-dev.prison.service.justice.gov.uk/health'},
    {name: 'token-verification-api', versionUrl: 'https://token-verification-api-dev.prison.service.justice.gov.uk/info', url: 'https://token-verification-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'prisoner-offender-search', versionUrl: 'https://prisoner-offender-search-dev.prison.service.justice.gov.uk/info', url: 'https://prisoner-offender-search-dev.prison.service.justice.gov.uk/health'},
    {name: 'pathfinder-api', versionUrl: 'https://dev-api.pathfinder.service.justice.gov.uk/info', url: 'https://dev-api.pathfinder.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases', url: 'https://manage-soc-cases-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'manage-soc-cases-api', versionUrl: 'https://manage-soc-cases-api-dev.hmpps.service.justice.gov.uk/info', url: 'https://manage-soc-cases-api-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'probation-offender-search-indexer', versionUrl: 'https://probation-search-indexer-dev.hmpps.service.justice.gov.uk/info', url: 'https://probation-search-indexer-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor', url: 'https://pin-phone-monitor-dev.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-pin-phone-monitor-api', versionUrl: 'https://pin-phone-monitor-api-dev.prison.service.justice.gov.uk/info', url: 'https://pin-phone-monitor-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'probation-offender-events', versionUrl: 'https://probation-offender-events-dev.hmpps.service.justice.gov.uk/info', url: 'https://probation-offender-events-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-template-kotlin', versionUrl: 'https://hmpps-template-kotlin-dev.hmpps.service.justice.gov.uk/info', url: 'https://hmpps-template-kotlin-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-services-feedback-and-support', url: 'https://support-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'manage-intelligence', url: 'https://manage-intelligence-dev.prison.service.justice.gov.uk/health'},
    {name: 'manage-intelligence-api', versionUrl: 'https://manage-intelligence-api-dev.prison.service.justice.gov.uk/info', url: 'https://manage-intelligence-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-submit-information-report', url: 'https://submit-information-report-dev.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-book-video-link', url: 'https://book-video-link-dev.prison.service.justice.gov.uk/health'},
    {name: 'court-register', versionUrl: 'https://court-register-dev.hmpps.service.justice.gov.uk/info', url: 'https://court-register-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'prison-register', versionUrl: 'https://prison-register-dev.hmpps.service.justice.gov.uk/info', url: 'https://prison-register-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-audit-api', versionUrl: 'https://audit-api-dev.hmpps.service.justice.gov.uk/info', url: 'https://audit-api-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers', url: 'https://registers-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-delius-update', versionUrl: 'https://registers-to-delius-update-dev.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-delius-update-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-registers-to-nomis-update', versionUrl: 'https://registers-to-nomis-update-dev.hmpps.service.justice.gov.uk/info', url: 'https://registers-to-nomis-update-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'calculate-journey-variable-payments', versionUrl: 'https://calculate-journey-variable-payments-dev.apps.live-1.cloud-platform.service.justice.gov.uk/info', url: 'https://calculate-journey-variable-payments-dev.apps.live-1.cloud-platform.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients', url: 'https://manage-restricted-patients-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-restricted-patients-api', versionUrl: 'https://restricted-patients-api-dev.hmpps.service.justice.gov.uk/info', url: 'https://restricted-patients-api-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'hmpps-welcome-people-into-prison-api', versionUrl: 'https://welcome-api-dev.prison.service.justice.gov.uk/info', url: 'https://welcome-api-dev.prison.service.justice.gov.uk/health'},
    {name: 'hmpps-welcome-people-into-prison-ui', url: 'https://welcome-dev.prison.service.justice.gov.uk/health'},
    {name: 'prison-to-nhs-update', versionUrl: 'https://prison-to-nhs-update-dev.prison.service.justice.gov.uk/info', url: 'https://prison-to-nhs-update-dev.prison.service.justice.gov.uk/health'},
    {name: 'nomis-user-roles-api', versionUrl: 'https://nomis-user-dev.aks-dev-1.studio-hosting.service.justice.gov.uk/info', url: 'https://nomis-user-dev.aks-dev-1.studio-hosting.service.justice.gov.uk/health'},
    {name: 'hmpps-manage-users-api', versionUrl: 'https://hmpps-manage-users-api-dev.hmpps.service.justice.gov.uk/info', url: 'https://hmpps-manage-users-api-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'create-and-vary-a-licence-api', versionUrl: 'https://create-and-vary-a-licence-api-dev.hmpps.service.justice.gov.uk/info', url: 'https://create-and-vary-a-licence-api-dev.hmpps.service.justice.gov.uk/health'},
    {name: 'create-and-vary-a-licence', url: 'https://create-and-vary-a-licence-dev.hmpps.service.justice.gov.uk/health'},
]

# Any service which does not have a preprod instance should be placed in this list.
# As a result the out-of-date version check will not be applied to them and they will report GREEN in preprod.

no_preprod_servers = []


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
      server_response = HTTParty.get(server[:url], headers: {Accept: 'text/html'}, timeout: $httptimeout)
    else
      server_response = HTTParty.get(server[:url], headers: {Accept: 'application/json'}, timeout: $httptimeout)
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

        status = result_json['status'] == 'UP' || result_json['status'] == 'OK' || result_json['healthy']

        if server[:versionUrl]
          begin
            version_response = HTTParty.get(server[:versionUrl], headers: {Accept: 'application/json'}, timeout: $httptimeout)

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
  if version == check_version
    {outofdate: 0}
    else
      begin
        version_as_date = Date.parse(version[0..10])
        check_version_as_date = Date.parse(check_version[0..10])
        days_out_of_date = (check_version_as_date - version_as_date).to_i
        {outofdate: (days_out_of_date + 3) * 8 }
      rescue
        {outofdate: 70 }
      end
  end
end

SCHEDULER.every '2m', first_in: 0 do |_job|
  dev_versions = dev_servers.map do |server|
    result = gather_health_data(server)
    send_event("#{server[:name]}-dev", result: result)
    {server[:name] => result[:checks][:VERSION]}
  end.reduce Hash.new, :merge

  staging_servers.map do |server|
    result = gather_health_data(server)
    result_with_colour = result.merge(add_outofdate(result[:checks][:VERSION], dev_versions[server[:name]]))
    send_event("#{server[:name]}-staging", result: result_with_colour)
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
