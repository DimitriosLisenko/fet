# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "codecov"
SimpleCov.formatter = SimpleCov::Formatter::Codecov

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "fet"

require "minitest/autorun"
