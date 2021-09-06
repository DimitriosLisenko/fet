# frozen_string_literal: true

require "test_helper"
require "securerandom"
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

      def setup
        @uuid = SecureRandom.uuid
      end

      def teardown
        Ruby2D::Window.clear
        Timecop.return
        FileUtils.rm_rf(tmp_directory)
      end

      def tmp_directory
        return "tmp/#{@uuid}"
      end

      # NOTE: this is not the ideal place for this, but running the game does require a fair bit of mocking
      def test_cli_play_listening
        options = { tempo: 120, degrees: 1, "key-type": "major", "next-on-correct": false }
        with_game_stubs { Fet::Cli::Play::Listening.run(nil, options, nil) }
      end
    end
  end
end
