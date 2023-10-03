module Config
  PROJECTS = [
    {
      name: 'hmpps-auth',
      versionPath: '/info',
      prodUrl: 'https://sign-in.hmpps.service.justice.gov.uk/auth',
      preprodUrl: 'https://sign-in-preprod.hmpps.service.justice.gov.uk/auth',
      devUrl: 'https://sign-in-dev.hmpps.service.justice.gov.uk/auth',
      title: 'HMPPS Auth',
      teams: ['sed', 'haar']
    },
    {
      name: 'prison-api',
      versionPath: '/info',
      prodUrl: 'https://api.prison.service.justice.gov.uk',
      preprodUrl: 'https://api-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://prison-api-dev.prison.service.justice.gov.uk',
      title: 'Prison API',
      teams: ['syscon', 'sed', 'haar', 'incentives'],
    },
    {
      name: 'hmpps-restricted-patients',
      prodUrl: 'https://manage-restricted-patients.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-restricted-patients-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-restricted-patients-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Restricted Patients',
    },
    {
      name: 'hmpps-restricted-patients-api',
      versionPath: '/info',
      prodUrl: 'https://restricted-patients-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://restricted-patients-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://restricted-patients-api-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Restricted Patients API',
    },
    {
      name: 'manage-key-workers',
      prodUrl: 'https://manage-key-workers.service.justice.gov.uk',
      preprodUrl: 'https://preprod.manage-key-workers.service.justice.gov.uk',
      devUrl: 'https://dev.manage-key-workers.service.justice.gov.uk',
      title: 'Key-worker UI',
    },
    {
      name: 'keyworker-api',
      versionPath: '/info',
      prodUrl: 'https://keyworker-api.prison.service.justice.gov.uk',
      preprodUrl: 'https://keyworker-api-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://keyworker-api-dev.prison.service.justice.gov.uk',
      title: 'Keyworker API',
    },
    {
      name: 'dps-core',
      repo: 'digital-prison-services',
      prodUrl: 'https://digital.prison.service.justice.gov.uk',
      preprodUrl: 'https://digital-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://digital-dev.prison.service.justice.gov.uk',
      title: 'DPS Core',
      teams: ['sed', 'haar','incentives'],
    },
    {
      name: 'whereabouts-api',
      versionPath: '/info',
      prodUrl: 'https://whereabouts-api.service.justice.gov.uk',
      preprodUrl: 'https://whereabouts-api-preprod.service.justice.gov.uk',
      devUrl: 'https://whereabouts-api-dev.service.justice.gov.uk',
      title: 'Whereabouts Api',
    },
    {
      name: 'manage-soc-cases',
      prodUrl: 'https://manage-soc-cases.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-soc-cases-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-soc-cases-dev.hmpps.service.justice.gov.uk',
      title: 'Manage SOC Cases',
      teams: ['sed'],
    },
    {
      name: 'offender-case-notes',
      versionPath: '/info',
      prodUrl: 'https://offender-case-notes.service.justice.gov.uk',
      preprodUrl: 'https://preprod.offender-case-notes.service.justice.gov.uk',
      devUrl: 'https://dev.offender-case-notes.service.justice.gov.uk',
      title: 'Offender Case Notes',
      teams: ['haar'],
    },
    {
      name: 'offender-categorisation',
      healthPath: '/healthcheck',
      prodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/offender-categorisation.service.justice.gov.uk',
      preprodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/preprod.offender-categorisation.service.justice.gov.uk',
      devUrl: 'https://health-kick.prison.service.justice.gov.uk/https/dev.offender-categorisation.service.justice.gov.uk',
      title: 'Offender Categorisation',
      teams: ['sed'],
    },
    {
      name: 'offender-risk-profiler',
      versionPath: '/info',
      prodUrl: 'https://offender-risk-profiler.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://offender-risk-profiler-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://offender-risk-profiler-dev.hmpps.service.justice.gov.uk',
      title: 'Offender Risk Profiler ',
      teams: ['sed'],
    },
    {
      name: 'prison-offender-events',
      versionPath: '/info',
      prodUrl: 'https://offender-events.prison.service.justice.gov.uk',
      preprodUrl: 'https://offender-events-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://offender-events-dev.prison.service.justice.gov.uk',
      title: 'Prison Offender Events',
      teams: ['syscon', 'incentives'],
    },
    {
      name: 'offender-events-ui',
      versionPath: '/info',
      devUrl: 'https://offender-events-ui-dev.prison.service.justice.gov.uk',
      title: 'Offender Events UI',
      teams: ['syscon'],
    },
    {
      name: 'prisoner-offender-search',
      versionPath: '/info',
      prodUrl: 'https://prisoner-offender-search.prison.service.justice.gov.uk',
      preprodUrl: 'https://prisoner-search-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://prisoner-search-dev.prison.service.justice.gov.uk',
      title: 'Prisoner Offender Search',
      teams: ['syscon', 'sed', 'incentives'],
    },
    {
      name: 'prisoner-search-indexer',
      versionPath: '/info',
      devUrl: 'https://prisoner-search-indexer-dev.prison.service.justice.gov.uk',
      title: 'Prisoner Search Indexer',
      teams: ['syscon'],
    },
    {
      name: 'licences',
      prodUrl: 'https://licences.prison.service.justice.gov.uk',
      preprodUrl: 'https://licences-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://licences-dev.prison.service.justice.gov.uk',
      title: 'Licences',
    },
    {
       name: 'prison-to-probation-update',
       versionPath: '/info',
       prodUrl: 'https://prison-to-probation-update.prison.service.justice.gov.uk',
       preprodUrl: 'https://prison-to-probation-update-preprod.prison.service.justice.gov.uk',
       devUrl: 'https://prison-to-probation-update-dev.prison.service.justice.gov.uk',
       title: 'Prison to Probation Update',
     },
    {
      name: 'pathfinder',
      prodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/pathfinder.service.justice.gov.uk',
      preprodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/preprod.pathfinder.service.justice.gov.uk',
      devUrl: 'https://dev.pathfinder.service.justice.gov.uk',
      title: 'Pathfinder',
      teams: ['sed'],
    },
    {
      name: 'use-of-force',
      prodUrl: 'https://use-of-force.service.justice.gov.uk',
      preprodUrl: 'https://preprod.use-of-force.service.justice.gov.uk',
      devUrl: 'https://dev.use-of-force.service.justice.gov.uk',
      title: 'Use of Force',
    },
    {
      name: 'token-verification-api',
      versionPath: '/info',
      prodUrl: 'https://token-verification-api.prison.service.justice.gov.uk',
      preprodUrl: 'https://token-verification-api-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://token-verification-api-dev.prison.service.justice.gov.uk',
      title: 'Token Verification api',
      teams: ['sed', 'haar'],
    },
    {
      name: 'probation-teams',
      versionPath: '/info',
      prodUrl: 'https://probation-teams.prison.service.justice.gov.uk',
      preprodUrl: 'https://probation-teams-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://probation-teams-dev.prison.service.justice.gov.uk',
      title: 'Probation Teams',
    },
    {
      name: 'pathfinder-api',
      versionPath: '/info',
      prodUrl: 'https://api.pathfinder.service.justice.gov.uk',
      preprodUrl: 'https://preprod-api.pathfinder.service.justice.gov.uk',
      devUrl: 'https://dev-api.pathfinder.service.justice.gov.uk',
      title: 'Pathfinder API',
      teams: ['sed'],
    },
    {
      name: 'prison-services-feedback-and-support',
      prodUrl: 'https://support.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://support-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://support-dev.hmpps.service.justice.gov.uk',
      title: 'Prison Services Feedback and Support',
    },
    {
      name: 'community-api',
      versionPath: '/info',
      prodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.probation.service.justice.gov.uk',
      preprodUrl: 'https://health-kick.prison.service.justice.gov.uk/https/community-api.pre-prod.delius.probation.hmpps.dsd.io',
      stagingUrl: 'https://community-api.stage.probation.service.justice.gov.uk',
      devUrl: 'https://community-api.test.probation.service.justice.gov.uk',
      title: 'Community API',
      teams: ['sed']
    },
    {
      name: 'probation-offender-search',
      versionPath: '/info',
      prodUrl: 'https://probation-offender-search.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://probation-offender-search-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://probation-offender-search-dev.hmpps.service.justice.gov.uk',
      title: 'Probation Offender Search',
      teams: ['sed']
    },
    {
      name: 'pcms',
      repo: 'hmpps-prisoner-communication-monitoring',
      prodUrl: 'https://pcms.prison.service.justice.gov.uk',
      preprodUrl: 'https://pcms-qa.prison.service.justice.gov.uk',
      devUrl: 'https://pcms-dev.prison.service.justice.gov.uk',
      title: 'PCMS',
      teams: ['sed'],
    },
    {
      name: 'pcms-api',
      versionPath: '/info',
      repo: 'hmpps-prisoner-communication-monitoring-api',
      prodUrl: 'https://pcms-api.prison.service.justice.gov.uk',
      preprodUrl: 'https://pcms-api-qa.prison.service.justice.gov.uk',
      devUrl: 'https://pcms-api-dev.prison.service.justice.gov.uk',
      title: 'PCMS API',
      teams: ['sed'],
    },
    {
      name: 'hmpps-manage-users',
      prodUrl: 'https://manage-users.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-users-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-users-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS User Manager',
      teams: ['haar'],
    },
    {
      name: 'hmpps-template-kotlin',
      versionPath: '/info',
      devUrl: 'https://hmpps-template-kotlin-dev.hmpps.service.justice.gov.uk',
      title: 'Template kotlin project',
    },
    {
      name: 'manage-intelligence',
      devUrl: 'https://manage-intelligence-dev.prison.service.justice.gov.uk',
      title: 'Manage Intelligence',
    },
    {
      name: 'manage-intelligence-api',
      versionPath: '/info',
      devUrl: 'https://manage-intelligence-api-dev.prison.service.justice.gov.uk',
      title: 'Manage Intelligence API',
    },
    {
      name: 'hmpps-submit-information-report',
      devUrl: 'https://submit-information-report-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Submit Information Report',
    },
    {
      name: 'calculate-journey-variable-payments',
      versionPath: '/info',
      prodUrl: 'https://calculate-journey-variable-payments.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://calculate-journey-variable-payments-preprod.apps.live-1.cloud-platform.service.justice.gov.uk',
      devUrl: 'https://calculate-journey-variable-payments-dev.apps.live-1.cloud-platform.service.justice.gov.uk',
      title: 'Calculate Journey Variable Payments',
    },
    {
      name: 'hmpps-book-secure-move-frontend',
      healthPath: '/healthcheck',
      prodUrl: 'https://bookasecuremove.service.justice.gov.uk',
      preprodUrl: 'https://hmpps-book-secure-move-frontend-preprod.apps.live-1.cloud-platform.service.justice.gov.uk',
      devUrl: 'https://hmpps-book-secure-move-frontend-staging.apps.live-1.cloud-platform.service.justice.gov.uk',
      title: 'HMPPS Book A Secure Move',
    },
    {
      name: 'hmpps-book-secure-move-api',
      prodUrl: 'https://api.bookasecuremove.service.justice.gov.uk',
      preprodUrl: 'https://hmpps-book-secure-move-api-preprod.apps.live-1.cloud-platform.service.justice.gov.uk',
      devUrl: 'https://hmpps-book-secure-move-api-staging.apps.live-1.cloud-platform.service.justice.gov.uk',
      title: 'HMPPS Book A Secure Move API',
    },
    {
      name: 'nomis-user-roles-api',
      versionPath: '/info',
      prodUrl: 'https://nomis-user.aks-live-1.studio-hosting.service.justice.gov.uk',
      preprodUrl: 'https://nomis-user-pp.aks-live-1.studio-hosting.service.justice.gov.uk',
      devUrl: 'https://nomis-user-roles-api-dev.prison.service.justice.gov.uk',
      title: 'NOMIS User Roles API',
      teams: ['haar'],
    },
    {
      name: 'hmpps-nomis-prisoner-api',
      versionPath: '/info',
      prodUrl: 'https://nomis-prisoner.aks-live-1.studio-hosting.service.justice.gov.uk',
      preprodUrl: 'https://nomis-prsner-pp.aks-live-1.studio-hosting.service.justice.gov.uk',
      devUrl: 'https://nomis-prisoner-api-dev.prison.service.justice.gov.uk',
      title: 'NOMIS Prisoner API',
      teams: ['syscon'],
    },
    {
      name: 'prison-register',
      versionPath: '/info',
      prodUrl: 'https://prison-register.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://prison-register-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://prison-register-dev.hmpps.service.justice.gov.uk',
      title: 'Prison Register',
      teams: ['haar'],
    },
    {
      name: 'hmpps-book-video-link',
      prodUrl: 'https://book-video-link.prison.service.justice.gov.uk',
      preprodUrl: 'https://book-video-link-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://book-video-link-dev.prison.service.justice.gov.uk',
      title: 'Book a video link',
    },
    {
      name: 'hmpps-audit-api',
      versionPath: '/info',
      prodUrl: 'https://audit-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://audit-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://audit-api-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Audit API',
      teams: ['haar'],
    },
    {
      name: 'hmpps-registers',
      prodUrl: 'https://registers.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://registers-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://registers-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Registers UI',
      teams: ['haar'],
    },
    {
      name: 'hmpps-welcome-people-into-prison-api',
      versionPath: '/info',
      prodUrl: 'https://welcome-api.prison.service.justice.gov.uk',
      preprodUrl: 'https://welcome-api-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://welcome-api-dev.prison.service.justice.gov.uk',
      title: 'HMPPS Welcome to Prison API',
    },
    {
      name: 'hmpps-welcome-people-into-prison-ui',
      prodUrl: 'https://welcome.prison.service.justice.gov.uk',
      preprodUrl: 'https://welcome-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://welcome-dev.prison.service.justice.gov.uk',
      title: 'HMPPS Welcome to Prison UI',
    },
    {
      name: 'manage-soc-cases-api',
      versionPath: '/info',
      prodUrl: 'https://manage-soc-cases-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-soc-cases-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-soc-cases-api-dev.hmpps.service.justice.gov.uk',
      title: 'Manage SOC Cases API',
      teams: ['sed'],
    },
    {
      name: 'hmpps-manage-adjudications',
      prodUrl: 'https://manage-adjudications.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-adjudications-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-adjudications-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Manage Adjudications',
    },
    {
      name: 'hmpps-manage-adjudications-api',
      versionPath: '/info',
      prodUrl: 'https://manage-adjudications-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-adjudications-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-adjudications-api-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Adjudications API',
    },
    {
      name: 'hmpps-manage-users-api',
      versionPath: '/info',
      prodUrl: 'https://manage-users-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-users-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-users-api-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Manage Users API',
      teams: ['haar'],
    },
    {
      name: 'create-and-vary-a-licence-api',
      versionPath: '/info',
      prodUrl: 'https://create-and-vary-a-licence-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://create-and-vary-a-licence-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://create-and-vary-a-licence-api-dev.hmpps.service.justice.gov.uk',
      title: 'Create and Vary a Licence API',
    },
    {
      name: 'create-and-vary-a-licence',
      prodUrl: 'https://create-and-vary-a-licence.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://create-and-vary-a-licence-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://create-and-vary-a-licence-dev.hmpps.service.justice.gov.uk',
      title: 'Create and Vary a Licence',
    },
    {
      name: 'calculate-release-dates-api',
      versionPath: '/info',
      prodUrl: 'https://calculate-release-dates-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://calculate-release-dates-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://calculate-release-dates-api-dev.hmpps.service.justice.gov.uk',
      title: 'Calculate Release Dates API',
    },
    {
      name: 'calculate-release-dates',
      prodUrl: 'https://calculate-release-dates.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://calculate-release-dates-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://calculate-release-dates-dev.hmpps.service.justice.gov.uk',
      title: 'Calculate Release Dates',
    },
    {
      name: 'book-a-prison-visit-staff-ui',
      prodUrl: 'https://manage-prison-visits.prison.service.justice.gov.uk',
      preprodUrl: 'https://manage-prison-visits-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://manage-prison-visits-dev.prison.service.justice.gov.uk',
      title: 'VSiP Staff UI',
    },
    {
      name: 'visit-scheduler',
      versionPath: '/info',
      prodUrl: 'https://visit-scheduler.prison.service.justice.gov.uk',
      preprodUrl: 'https://visit-scheduler-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://visit-scheduler-dev.prison.service.justice.gov.uk',
      title: 'Visit Scheduler API',
    },
    {
      name: 'hmpps-prisoner-to-nomis-update',
      versionPath: '/info',
      prodUrl: 'https://prisoner-to-nomis-update.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://prisoner-to-nomis-update-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://prisoner-to-nomis-update-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Prisoner to NOMIS Update',
      teams: ['syscon', 'incentives'],
    },
    {
      name: 'hmpps-prisoner-from-nomis-migration',
      versionPath: '/info',
      prodUrl: 'https://prisoner-nomis-migration.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://prisoner-nomis-migration-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://prisoner-nomis-migration-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Prisoner from NOMIS Migration',
      teams: ['syscon'],
    },
    {
      name: 'hmpps-nomis-sync-dashboard',
      prodUrl: 'https://nomis-sync-dashboard.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://nomis-sync-dashboard-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://nomis-sync-dashboard-dev.hmpps.service.justice.gov.uk',
      title: 'NOMIS Migration Dashboard',
      teams: ['syscon'],
    },
    {
      name: 'hmpps-nomis-mapping-service',
      versionPath: '/info',
      prodUrl: 'https://nomis-sync-prisoner-mapping.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://nomis-sync-prisoner-mapping-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://nomis-sync-prisoner-mapping-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS NOMIS Visits Mapping',
      teams: ['syscon', 'incentives']
    },
    {
      name: 'hmpps-incentives-ui',
      prodUrl: 'https://incentives-ui.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://incentives-ui-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://incentives-ui-dev.hmpps.service.justice.gov.uk',
      title: 'Incentives UI',
      teams: ['incentives'],
    },
    {
      name: 'hmpps-incentives-api',
      versionPath: '/info',
      prodUrl: 'https://incentives-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://incentives-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://incentives-api-dev.hmpps.service.justice.gov.uk',
      title: 'Incentives API',
      teams: ['incentives'],
    },
    {
      name: 'send-legal-mail-to-prisons-api',
      versionPath: '/info',
      prodUrl: 'https://send-legal-mail-api.prison.service.justice.gov.uk',
      preprodUrl: 'https://send-legal-mail-api-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://send-legal-mail-api-dev.prison.service.justice.gov.uk',
      title: 'Send Legal Mail To Prisons API',
    },
    {
      name: 'send-legal-mail-to-prisons',
      prodUrl: 'https://send-legal-mail.prison.service.justice.gov.uk',
      preprodUrl: 'https://send-legal-mail-preprod.prison.service.justice.gov.uk',
      devUrl: 'https://send-legal-mail-dev.prison.service.justice.gov.uk',
      title: 'Send Legal Mail To Prisons',
    },
    {
      name: 'check-my-diary',
      prodUrl: 'https://checkmydiary.service.justice.gov.uk',
      preprodUrl: 'https://check-my-diary-preprod.prison.service.justice.gov.uk',
      title: 'Check My Diary',
      teams: ['syscon'],
    },
    {
      name: 'cmd-api',
      versionPath: '/info',
      prodUrl: 'https://health-kick.prison.service.justice.gov.uk/http/cmd-api.check-my-diary-prod.svc.cluster.local',
      preprodUrl: 'https://health-kick.prison.service.justice.gov.uk/http/cmd-api.check-my-diary-preprod.svc.cluster.local',
      title: 'CMD API',
      teams: ['syscon'],
    },
    {
      name: 'csr-api',
      versionPath: '/info',
      prodUrl: 'https://csr-api.aks-live-1.studio-hosting.service.justice.gov.uk',
      preprodUrl: 'https://csr-api-prprod.aks-live-1.studio-hosting.service.justice.gov.uk',
      title: 'CSR API',
      teams: ['syscon'],
    },
    {
      name: 'manage-offences-api',
      versionPath: '/info',
      prodUrl: 'https://manage-offences-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-offences-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-offences-api-dev.hmpps.service.justice.gov.uk',
      title: 'Manage offences API',
    },
    {
      name: 'manage-offences',
      prodUrl: 'https://manage-offences.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://manage-offences-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://manage-offences-dev.hmpps.service.justice.gov.uk',
      title: 'Manage offences',
    },
    {
      name: 'hmpps-historical-prisoner',
      devUrl: 'https://historical-prisoner-dev.prison.service.justice.gov.uk',
      title: 'Historical Prisoner',
      teams: ['haar'],
    },
    {
      name: 'hmpps-historical-prisoner-api',
      versionPath: '/info',
      devUrl: 'https://historical-prisoner-api-dev.prison.service.justice.gov.uk',
      title: 'Historical Prisoner API',
      teams: ['haar'],
    },
    {
      name: 'hmpps-activities-management',
      devUrl: 'https://activities-dev.prison.service.justice.gov.uk',
      title: 'Activities Management UI',
      teams: ['activities'],
    },
    {
      name: 'hmpps-activities-management-api',
      versionPath: '/info',
      devUrl: 'https://activities-api-dev.prison.service.justice.gov.uk',
      title: 'Activities Management API',
      teams: ['activities'],
    },
    {
      name: 'hmpps-external-users-api',
      versionPath: '/info',
      prodUrl: 'https://external-users-api.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://external-users-api-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://external-users-api-dev.hmpps.service.justice.gov.uk',
      title: 'External Users API',
      teams: ['haar'],
    },
    {
      name: 'hmpps-prisoner-events',
      versionPath: '/info',
      prodUrl: 'https://prisoner-events.aks-live-1.studio-hosting.service.justice.gov.uk',
      preprodUrl: 'https://prsnr-events-pp.aks-live-1.studio-hosting.service.justice.gov.uk',
      devUrl: 'https://prisoner-events-dev.prison.service.justice.gov.uk',
      title: 'HMPPS Prisoner Events',
      teams: ['syscon'],
    },
    {
      name: 'hmpps-domain-event-logger',
      versionPath: '/info',
      prodUrl: 'https://domain-event-logger.hmpps.service.justice.gov.uk',
      preprodUrl: 'https://domain-event-logger-preprod.hmpps.service.justice.gov.uk',
      devUrl: 'https://domain-event-logger-dev.hmpps.service.justice.gov.uk',
      title: 'HMPPS Domain Event Logger',
      teams: ['syscon'],
    },

  ]

  TEAMS = [
    { name: 'activities', title: 'Activities Management' },
    { name: 'haar', title: 'HMPPS Auth, Audit & Registers' },
    { name: 'incentives', title: 'Incentives' },
    { name: 'syscon', title: 'Syscon Projects' },
    { name: 'sed', title: 'Secure Estate Digital' }
  ]
  TEAMS_TITLES = TEAMS.map { |team| [team[:name], team[:title]] }.to_h

  TEAM_PROJECTS = TEAMS.map { |team|
    [team[:name], PROJECTS.filter { |project| project[:teams]&.include? team[:name] }]
  }.to_h
end
