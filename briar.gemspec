# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'briar/version'

Gem::Specification.new do |gem|
  gem.name          = "briar"
  gem.version       = Briar::VERSION
  gem.authors       = ["Joshua Moody"]
  gem.email         = ["joshuajmoody@gmail.com"]
  gem.description   = 'extends calabash-ios steps'
  gem.summary       = "briar-#{gem.version}"
  gem.homepage      = "https://github.com/jmoody/briar"

  gem.add_runtime_dependency 'calabash-cucumber'
  gem.add_runtime_dependency 'builder'    
  gem.add_runtime_dependency 'bundler'
  gem.add_runtime_dependency 'CFPropertyList'
  gem.add_runtime_dependency 'cucumber'
  gem.add_runtime_dependency 'diff-lcs'
  gem.add_runtime_dependency 'geocoder'
  gem.add_runtime_dependency 'gherkin'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'multi_json'
  gem.add_runtime_dependency 'location-one'
  gem.add_runtime_dependency 'net-http-persistent'
  gem.add_runtime_dependency 'rack'
  gem.add_runtime_dependency 'rack-protection'
  gem.add_runtime_dependency 'rake', '10.0.3'
  gem.add_runtime_dependency 'rubygems-bundler'
  gem.add_runtime_dependency 'sim_launcher'
  gem.add_runtime_dependency 'sinatra'
  gem.add_runtime_dependency 'slowhandcuke'
  gem.add_runtime_dependency 'tilt'
  gem.add_runtime_dependency 'syntax'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rvm'


  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
