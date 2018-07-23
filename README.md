Capistrano task for automatic and unicorn configuration

This gem customize from [capistrano-unicorn-nginx](https://github.com/capistrano-plugins/capistrano-unicorn-nginx), and support for Ubuntu server, CentOs server, EC2 server...

Highlight of Gem:

* Automatic config unicorn for rails app
* Zero downtime deployments enabled

## Installation

Add this to `Gemfile`:
```
group :development do
    gem "capistrano"
    gem "capistrano-simple-unicorn"
end
```
And then:
```
$ bundle install
```
## Setup and usage

1. Update `Capfile`
```
require "capistrano/simple_unicorn"
```
2. Run deploy
```
$ bundle exec cap production deploy
```

## configuration

Default value:
```
set :unicorn_service, -> { "unicorn_#{fetch(:application)}" }
set :user_home_path, -> { "/home/#{fetch(:user)}" }
set :unicorn_config_file, -> { shared_path.join("config", "unicorn.rb") }
set :unicorn_pid_file, -> { shared_path.join("tmp", "pids", "unicorn.pid") }
set :unicorn_sock_file, -> { shared_path.join("tmp", "unicorn.sock") }
set :unicorn_log_file, -> { shaed_path.join("log", "unicorn.stdout.log") }
set :unicorn_error_log_file, -> {shared_path.join("log","unicorn.stderr.log")}
set :ruby_version, -> { fetch(:rvm_ruby_version) || fetch(:rbenv_ruby) }
set :unicorn_worker_processes, 2
set :unicorn_timeout, 30
```

If you want to change config:
Example
```
# in config/deploy/production.rb
set :unicorn_worker_processes, 4
set :unicorn_timeout, 60
```

## scrip remote
* start|stop|restart unicron, run:
```
$ cap production unicorn:start
$ cap production unicorn:stop
$ cap production unicorn:restart
```
