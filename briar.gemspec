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

  gem.files = `git ls-files`.split("\n") - ['.gitignore']
  gem.executables = 'briar'
  gem.require_paths = ['lib', 'features']

  gem.platform = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.3'

  gem.add_runtime_dependency 'rbx-require-relative', '~> 0.0'
  gem.add_runtime_dependency 'calabash-cucumber', '>= 0.9.168'
  gem.add_runtime_dependency 'dotenv', '~> 0.9'
  gem.add_runtime_dependency 'ansi', '~> 1.4'
  gem.add_runtime_dependency 'rainbow', '~> 2.0'
  # downgrade because of xtc gem - wants ~> 1.4
  gem.add_runtime_dependency 'retriable', '< 1.5', '>= 1.3'
  # test cloud requires 1.3.5, we want ~> 1.6
  gem.add_runtime_dependency 'bundler', '< 1.7', '>= 1.3.5'
  gem.add_runtime_dependency 'xamarin-test-cloud', '< 1.0', '>= 0.9.35'
  gem.add_runtime_dependency 'rake', '~> 10.3'

  # downgrading to 1.0.0 from 1.2.0
  # https://github.com/xamarin/test-cloud-command-line/issues/3
  gem.add_runtime_dependency 'syntax', '~>1.0'

  gem.add_development_dependency 'travis', '~> 1.7'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'xcpretty', '0.1.6'

end
