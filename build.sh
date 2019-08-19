#!/bin/bash -e
bundle install
bundle exec rspec
cd examples/MyApp
bundle install
bundle exec appraisal install
bundle exec appraisal rake doc:api

echo ALL TESTS SUCCESSFUL!
