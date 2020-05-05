DPS Monitoring
====
Monitoring for the DPS Services and Projects

The project is based on Smashing.

Installs
--------

Packages needed
----
```
ruby
ruby-dev
build-essential
nodejs
(or equivalent for your platform)
```

e.g. For Ubuntu this was:

```
$ sudo apt-get install ruby ruby-dev build-essential nodejs

```


Build
----
```
$ sudo gem install bundler
$ sudo gem install smashing
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


## Running Locally
To test the application it is best to run using docker

Build first
```shell script
docker build -t dps-monitor .
```
 Run:
```shell script
docker run -p3030:3030 --env CIRCLE_CI_TOKEN=******* --name dps-monitor -d -t dps-monitor
```
Test in browser:
```
http://localhost:3030
``` 
Stop:
```shell script
docker stop dps-monitor
docker rm -vf dps-monitor
```