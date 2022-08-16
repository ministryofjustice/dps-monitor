DPS Monitoring
====
Monitoring for the DPS Services and Projects.

The project is based on Smashing.

Installs
--------

The docker file uses an image based on Ruby 3.1.0 so local installs should match this and use bundler:2.3.3

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

or (depending on your Ubuntu version)

Install RVM and use it to install version 3.1.0

```
$ rvm install 3.1.0
```


Build
----
These steps will also pull the latest dependencies, potentially fixing any vulnerability issues
```
$ sudo gem install bundler (or bundler:2.3.3 if your OS does not match exactly)
$ sudo gem install smashing
$ cd dps-monitor/
$ rm Gemfile.lock   (will not build on some platforms without this - Ubuntu)
$ bundle install    (will recreate Gemfile.lock)
```

Auditing - pre-check as could fail in circle tests
--------------------------------------------------

Run the following after a bundle install has completed:

```
$ bundle exec bundle audit check --update
```

If there are vulnerabilities reported, consider updating the version of bundler-audit (current 0.9.0) or other
gems reporting issues.

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
All merges to main are built & deployed automatically to cloud platform
```

Further Reading on Smashing
----
Check out http://smashing.github.io/ for more information.


Deployment Configuration
----

Requires the following environment variables to be available locally when running:
Get a Circle CI token from https://app.circleci.com/settings/user/tokens

 * CIRCLE_CI_TOKEN - a valid circle API access token
 
Run
----
```
CIRCLE_CI_TOKEN=************ smashing start
```

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
docker run -p3030:3030 --env CIRCLE_CI_TOKEN=******* --name dps-monitor -d -t dps-monitor:latest
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

## Trivy scan issues in CircleCI overnight jobs

These can be raised for issues relating to the packages that are installed at the time the image is built.
A docker image rebuild will usually sort these out as it pulls in the latest packages available at the time, including any fixes.
You can either:
 - Build the image locally (instructions above) to see which versions of packages are used.
 - Navigate to CircleCI and rebuild the latest `build-test-and-deploy` commit on `main`. This will deploy a new version and should hopefully fix the Trivy issue.  
