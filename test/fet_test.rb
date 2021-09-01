# frozen_string_literal: true

require "test_helper"

class FetTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Fet::VERSION
  end
end
