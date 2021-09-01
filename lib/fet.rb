# frozen_string_literal: true

require "ice_nine"
require "ice_nine/core_ext/object"

Dir["#{__dir__}/fet/**/*.rb"].each { |file| require_relative(file.delete_prefix("#{__dir__}/")) }

# Base Gem module
module Fet
end
