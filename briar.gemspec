# -*- encoding: utf-8 -*-

# ==> require_relative 'lib/briar/version' <==
# bundler on 1.9.3 complains
# 'Does it try to require a relative path? That's been removed in Ruby 1.9'
# 
# this is the current _best_ solution
$:.push File.expand_path('../lib', __FILE__)
require 'briar/version'

# experimental
# not yet
# $:.push File.expand_path("../features", __FILE__)

Gem::Specification.new do |gem|
  gem.name = 'briar'
  gem.version = Briar::VERSION
  gem.authors = ['Joshua Moody']
  gem.email = ['joshuajmoody@gmail.com']
  gem.description = 'extends calabash-ios steps'
  gem.summary = "briar-#{gem.version}"
  gem.homepage = 'https://github.com/jmoody/briar'
  gem.license = 'MIT'

  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.8.7'

  gem.add_runtime_dependency 'rbx-require-relative', '~> 0.0'
  gem.add_runtime_dependency 'calabash-cucumber', '~> 0.9.169'
  gem.add_runtime_dependency 'rake', '~>10.1'
  gem.add_runtime_dependency 'dotenv', '~> 0.9'
  gem.add_runtime_dependency 'ansi', '~> 1.4'
  gem.add_runtime_dependency 'rainbow', '~> 1.99'
  gem.add_runtime_dependency 'pry', '~> 0.9'
  gem.add_runtime_dependency 'rspec'

  # downgrading to 1.0.0 from 1.2.0
  # https://github.com/xamarin/test-cloud-command-line/issues/3
  gem.add_runtime_dependency 'syntax', '~>1.0.0'

  gem.files = `git ls-files`.split("\n") - ['.gitignore']
  gem.executables = 'briar'
  gem.test_files = gem.files.grep(%r{^(test|spec)/})
  gem.require_paths = ['lib', 'features']
end
