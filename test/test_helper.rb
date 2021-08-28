# frozen_string_literal: true

require "simplecov"
SimpleCov.start

unless ENV['CODECOV_TOKEN'].nil?
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fet"

require "minitest/autorun"
