# frozen_string_literal: true

require "ice_nine"
require "ice_nine/core_ext/object"

Dir["lib/fet/*.rb"].each { |file| require_relative(file.delete_prefix("lib/")) }
