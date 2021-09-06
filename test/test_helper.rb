# frozen_string_literal: true

require "simplecov"
require "timecop"

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

def assert_difference(value_lambda, difference)
  old_value = value_lambda.call
  yield
  new_value = value_lambda.call
  assert_equal(old_value + difference, new_value)
end
