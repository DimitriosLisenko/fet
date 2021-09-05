# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  enable_coverage :branch
end

SimpleCov.minimum_coverage(line: 100, branch: 100)
unless ENV["CODECOV_TOKEN"].nil?
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fet"

require "minitest/autorun"
require "minitest/stub_any_instance"
