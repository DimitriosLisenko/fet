# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem"s dependencies in fet.gemspec
gemspec

gem 'gli', '~> 2.20', '>= 2.20.1'

group :test do
  gem "minitest", "~> 5.0"
  gem "simplecov", "~> 0.21.2"
end

group :test, :development do
  gem "codecov", "~> 0.6.0"
  gem "pry-byebug", "~> 3.9"
  gem "rake", "~> 13.0"
  gem "rubocop", "~> 1.7"
end
