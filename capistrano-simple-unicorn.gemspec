# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/simple_unicorn/version'

Gem::Specification.new do |s|
  s.name          = 'capistrano-simple-unicorn'
  s.version       = Capistrano::SimpleUnicorn::VERSION
  s.date          = '2018-07-20'
  s.summary       = "Capistrano tasks for automatic and sensible unicorn configuration"
  s.description   = <<-EOF.gsub(/^\s+/, '')
    Capistrano tasks for automatic and sensible unicorn configuration
    Work *only* with Capistrano 3+
    Enable Zero downtime deployments of rails application.
    Support for Ubuntu server and Centos, EC2... server same fedora, .
    This gem customize from https://github.com/bruno-/capistrano-unicorn-nginx
  EOF
  s.description   = "Capistrano deploy rails app with unicorn zero downtime."
  s.authors       = ["truongkma"]
  s.email         = 'truong.nd1902@gmail.com'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage      = 'http://rubygems.org/gems/capistrano-simple-unicorn'
  s.license       = 'MIT'

  s.add_runtime_dependency 'capistrano', '~> 3.1'
  s.add_runtime_dependency 'sshkit', '~> 1.2'

  s.add_development_dependency 'rake', '~> 0'
end
