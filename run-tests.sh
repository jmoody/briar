#!/bin/sh
bundle update
bundle install
bundle exec rspec spec
