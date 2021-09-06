# frozen_string_literal: true

require "test_helper"
require_relative "game_keyboard_input_tester"
require_relative "game_mouse_input_tester"
require_relative "game_test_helper"
require_relative "game_update_loop_tester"

module Fet
  module Ui
    class GameTest < Minitest::Test
      include GameTestHelper

      include GameKeyboardInputTester
      include GameMouseInputTester
      include GameUpdateLoopTester

      def teardown
        Ruby2D::Window.clear
        Timecop.return
      end
    end
  end
end
