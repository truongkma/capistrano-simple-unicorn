require 'capistrano/simple_unicorn/helpers'
include Capistrano::SimpleUnicorn::Helpers

namespace :load do
  task :defaults do
    set :unicorn_service, -> { "unicorn_#{fetch(:application)}" }
    set :user_home_path, -> { "/home/#{fetch(:user)}" }
    set :unicorn_config_file, -> { unicorn_config_file }
    set :unicorn_pid_file, -> { unicorn_pid_file }
    set :unicorn_sock_file, -> { unicorn_sock_file }
    set :unicorn_log_file, -> { unicorn_log_file }
    set :unicorn_error_log_file, -> { unicorn_error_log_file }
    set :ruby_version, -> { fetch(:rvm_ruby_version) || fetch(:rbenv_ruby) }
    set :unicorn_worker_processes, 2
    set :unicorn_timeout, 30

    set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids')
  end
end

namespace :unicorn do
  desc 'Unicorn Initializer'
  task :unicorn_init do
    on roles :app do
      sudo_upload! template('unicorn_init.erb'), unicorn_initd_file
      execute :chmod, '+x', unicorn_initd_file
      if os_is_ubuntu?
        sudo 'update-rc.d', '-f', fetch(:unicorn_service), 'defaults'
      else
        sudo 'chkconfig', '--add', fetch(:unicorn_service)
      end
    end
  end

  desc 'Setup unicorn config'
  task :setup_unicorn_config do
    on roles :app do
      unless file_exists? fetch(:unicorn_config_file)
        execute :mkdir, '-pv', File.dirname(fetch(:unicorn_config_file))
      end
      upload! template('unicorn.rb.erb'), fetch(:unicorn_config_file)
    end
  end

  %w[start stop restart upgrade].each do |action|
    desc "#{action} unicorn"
    task action do
      on roles :app do
        sudo :service, fetch(:unicorn_service), action
      end
    end
  end

  desc 'restart unicorn'
  task 'reload' do
    on roles :app do
      invoke "unicorn:unicorn_init" unless file_exists?(unicorn_initd_file)
      invoke 'unicorn:setup_unicorn_config'
      if test "[ -f #{fetch(:unicorn_pid)} ]"
        sudo 'service', fetch(:unicorn_service), 'restart'
      else
        sudo 'service', fetch(:unicorn_service), 'start'
      end
    end
  end
end

namespace :deploy do
  after :publishing, 'unicorn:reload'
end
