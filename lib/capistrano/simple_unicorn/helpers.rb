require 'erb'

module Capistrano
  module SimpleUnicorn
    module Helpers
      def template template_name
        StringIO.new(template_to_s(template_name))
      end

      def template_to_s template_name
        config_file = File.join(File.dirname(__FILE__), "../../generators/templates/#{template_name}")
        ERB.new(File.read(config_file), nil, '-').result(binding)
      end

      def sudo_upload! from, to
        filename = File.basename(to)
        to_dir = File.dirname(to)
        tmp_file = "/tmp/#{filename}"
        upload! from, tmp_file
        sudo :mv, tmp_file, to_dir
      end

      def file_exists? path
        test "[ -e #{path} ]"
      end

      def deploy_user
        capture :id, '-un'
      end

      def os_is_ubuntu?
        capture(:cat, "/etc/*-release").include? "ubuntu"
      end

      def unicorn_initd_file
        "/etc/init.d/#{fetch(:unicorn_service)}"
      end

      def unicorn_sock_file
        shared_path.join("tmp", "unicorn.sock")
      end

      def unicorn_config_file
        shared_path.join("config", "unicorn.rb")
      end

      def unicorn_pid_file
        shared_path.join("tmp", "pids", "unicorn.pid")
      end

      def unicorn_error_log_file
        shared_path.join("log", "unicorn.stderr.log")
      end

      def unicorn_log_file
        shared_path.join("log", "unicorn.stdout.log")
      end
    end
  end
end
