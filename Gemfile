# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's runtime dependencies in fet.gemspec
gemspec

group :test do
  gem "minitest", "~> 5.0"
  gem "minitest-stub_any_instance", "~> 1.0", ">= 1.0.2"
  gem "simplecov", "~> 0.21.2"
end

group :test, :development do
  gem "codecov", "~> 0.6.0"
  gem "pry-byebug", "~> 3.9"
  gem "rake", "~> 13.0"
  gem "rdoc", "~> 6.3", ">= 6.3.2"
  gem "rubocop", "~> 1.7"
end
