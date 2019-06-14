NOTM Monitoring
====
Monitoring for the Nomis Elite API and NOTM projects.

The project is based on Smashing.

Installs
--------

Packages needed
----
```
ruby
rub-dev
build-essential
nodejs
(or equivalent for your platform)
```


Build
----
```
$ gem install bundler
$ gem install smashing
$ cd notm-monitor/
$ rm Gemfile.lock   (will not build on some platforms without this - Ubuntu)
$ bundle install
```

Run
----
```
smashing start
```

Local
----
* Overview - http://localhost:3030/             - shows overview of 'production' services & build info
* CI status - http://localhost:3030/circle      - shows circle CI build status
* Server health - http://localhost:3030/health  - shows health of all services, in all environments
* Activity - http://localhost:3030/stats        - incomplete?

Deployment
----

```
All merges to master are built &deployed automatically to Heroku
```

Heroku
----

https://notm-monitor.herokuapp.com/circle


Further Reading on Smashing
----
Check out http://smashing.github.io/ for more information.


Deployment Configuration
----

Requires the following environment variables to be available locally when running:

 * CIRCLE_CI_TOKEN - a valid circle API access token
 
 
Dashboard Configuration
----

1. Edit dashboards/circle.erb to add projects to the build monitor
2. Edit dashboards/health.erb to add grid items for health checks
3. Edit the projects element in jobs/circle_ci.rb to match your changes to CI statuses shown in circle.erb
4. Edit the projects element in jobs/health.rb
5. Edit dashboards/overview.erb to add production service info
