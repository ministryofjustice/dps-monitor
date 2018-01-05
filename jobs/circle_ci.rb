require 'httparty'
# require 'digest/md5'

projects = [
  { vcs: 'bitbucket', user: 'cool_syscon_team', repo: 'mobile', branch: 'nomis-api'},
  { vcs: 'bitbucket', user: 'cool_syscon_team', repo: 'elite2-web', branch: 'master'},
  { vcs: 'github', user: 'ministryofjustice', repo: 'nomis-api', branch: 'dev'}
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

  latest_build = api_json.select{ |build| build['status'] != 'queued' }.first
  email_hash = Digest::MD5.hexdigest(latest_build['author_email'])
  build_id = "#{latest_build['branch']}, build ##{latest_build['build_num']}"

  data = {
    build_id: build_id,
    repo: "#{project[:repo]}",
    branch: "#{latest_build['branch']}",
    time: "#{calculate_time(latest_build['stop_time'])}",
    state: "#{latest_build['status'].capitalize}",
    widget_class: "#{translate_status_to_class(latest_build['status'])}",
    committer_name: latest_build['committer_name'],
    commit_body: latest_build['subject'],
    avatar_url: "http://www.gravatar.com/avatar/#{email_hash}"
  }
  return data
end

SCHEDULER.every '10s', :first_in => 0  do
  projects.each do |project|
    data_id = "circle-ci-#{project[:user]}-#{project[:repo]}-#{project[:branch]}"
    data = build_data(project, ENV['CIRCLE_CI_TOKEN'])
    send_event(data_id, data) unless data.empty?
  end
end
