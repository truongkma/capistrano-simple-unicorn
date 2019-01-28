require 'capistrano/simple_unicorn/helpers'
include Capistrano::SimpleUnicorn::Helpers

namespace :load do
  task :defaults do
    set :nginx_listen_port, 80
    set :nginx_server_name, "_"
    set :nginx_upstream_name, -> { "#{fetch(:application)}" }
    set :nginx_config_name, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
    set :nginx_fail_timeout, 0
    set :nginx_access_log_file, -> { "/var/log/nginx/#{fetch(:nginx_config_name)}.access.log" }
    set :nginx_error_log_file, -> { "/var/log/nginx/#{fetch(:nginx_config_name)}.error.log" }
    set :nginx_upstream_file, -> { "#{fetch(:unicorn_sock_path)}" }
  end
end

namespace :nginx do
  desc 'Setup nginx configuration'
  task :setup do
    on roles :web do
      unless file_exists?(nginx_config_file)
        sudo_upload! template('nginx_conf.erb'), nginx_config_file
      end
    end
  end

  %w[stop start restart reload].each do |action|
    desc "#{action} nginx"
    task action do
      on roles :web do
        sudo :service, "nginx", action
      end
    end
  end
end
