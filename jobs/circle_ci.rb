require 'httparty'
# require 'digest/md5'

projects = [
  { vcs: 'github', user: 'ministryofjustice', repo: 'keyworker-ui', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'keyworker-service', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prisonstaffhub', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'manage-hmpps-auth-accounts', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'offender-categorisation', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'offender-risk-profiler', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'new-nomis-ui', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-auth', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prison-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'community-api', branch: 'master'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'whereabouts-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'offender-case-notes', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'licences', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'offender-assessments-api', branch: 'master'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'use-of-force', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'pathfinder', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prison-offender-events', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'dps-data-compliance', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'case-notes-to-probation', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'probation-teams', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prison-to-probation-update', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'probation-offender-search', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'check-my-diary', branch: 'master'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'token-verification-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prisoner-offender-search', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'pathfinder-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'manage-soc-cases', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'probation-offender-search-indexer', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-pin-phone-monitor', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-pin-phone-monitor-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'probation-offender-events', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-template-kotlin', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prison-services-feedback-and-support', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'manage-intelligence', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'manage-intelligence-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-book-video-link', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'court-register', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'prison-register', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-audit-api', branch: 'main'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'hmpps-registers', branch: 'main'},
]

def duration(time)
  secs  = time.to_int
  mins  = secs / 60
  hours = mins / 60
  days  = hours / 24

  if days > 0
    "#{days}d #{hours % 24}h ago"
  elsif hours > 0
    "#{hours}h #{mins % 60}m ago"
  elsif mins > 0
    "#{mins}m #{secs % 60}s ago"
  elsif secs >= 0
    "#{secs}s ago"
  end
end

def calculate_time(finished)
  finished ? duration(Time.now - Time.parse(finished)) : "--"
end

def translate_status_to_class(status)
  statuses = {
    'success' => 'passed',
      'fixed' => 'passed',
    'running' => 'pending',
     'failed' => 'failed'
  }
  statuses[status] || 'pending'
end


def build_data(project, auth_token)
  api_url = 'https://circleci.com/api/v1.1/project/%s/%s/%s/tree/%s?circle-token=%s&limit=1'
  api_url = api_url % [project[:vcs], project[:user], project[:repo], project[:branch], auth_token]
  api_response =  HTTParty.get(api_url, :headers => { "Accept" => "application/json" } )
  api_json = JSON.parse(api_response.body)
  return {} if api_json.empty?
  email_hash = nil

  latest_build = api_json.select{ |build| build['status'] != 'queued' }.first
  unless latest_build.nil? or latest_build.empty?
    email = latest_build['author_email']
    unless email.nil?
       email_hash = Digest::MD5.hexdigest(email)
    end

    build_id = "#{latest_build['branch']}, build ##{latest_build['build_num']}"

    build_url = latest_build['build_url']
    workflow_id = latest_build.dig('workflows', 'workflow_id')
    if workflow_id
      build_url = 'https://circleci.com/workflow-run/%s' % [workflow_id]
    end

    data = {
      build_id: build_id,
      repo: "#{project[:repo]}",
      branch: "#{latest_build['branch']}",
      time: "#{calculate_time(latest_build['stop_time'])}",
      state: "#{latest_build['status'].capitalize}",
      widget_class: "#{translate_status_to_class(latest_build['status'])}",
      committer_name: latest_build['committer_name'],
      commit_body: latest_build['subject'],
      build_url: build_url,
      avatar_url: "http://www.gravatar.com/avatar/#{email_hash}"
    }
    return data
  end
  nil
end

SCHEDULER.every '5m', :first_in => 0  do
  projects.each do |project|
    data_id = "circle-ci-#{project[:user]}-#{project[:repo]}-#{project[:branch]}"
    data = build_data(project, ENV['CIRCLE_CI_TOKEN'])
    send_event(data_id, data) unless (data.nil? or data.empty?)
  end
end

