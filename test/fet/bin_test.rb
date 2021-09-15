# frozen_string_literal: true

require "test_helper"

module Fet
  class BinTest < Minitest::Test
    def test_bin
      capture_subprocess_io do
        load_bin
        test_help_command
        test_unknown_command
      end
    end

    private

    def test_help_command
      assert_equal(0, App.run(["help"]))
    end

    def test_unknown_command
      assert_equal(64, App.run(["unknown_command"]))
    end
  end
end
