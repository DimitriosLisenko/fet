# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameUpdateLoopTester
      def test_timer_update_loop
        Timecop.freeze(DateTime.now)
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)

        stub_game_timer_current_time do
          game_instance_test(game) do
            Timecop.freeze(DateTime.now + (10.0 / 24 / 60 / 60))
            game.handle_update_loop
            assert_timer_state(game, 10, "00:10")
          end
        end
      end

      def test_timer_hours
        Timecop.freeze(DateTime.now)
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)

        stub_game_timer_current_time do
          game_instance_test(game) do
            Timecop.freeze(DateTime.now + (2.0 / 24))
            game.handle_update_loop
            assert_timer_state(game, 2 * 60 * 60, "02:00:00")
          end
        end
      end

      private

      # NOTE: Timecop does not yet support freezing Process.clock_gettime, so do this in the meantime
      def stub_game_timer_current_time
        Fet::Ui::Timer.stub_any_instance(:current_time, method(:unix_time)) { yield }
      end

      def unix_time
        Time.now.to_i
      end

      def assert_timer_state(game, seconds, output)
        assert_equal(seconds, game.timer.seconds_elapsed)
        assert_equal(output, game.timer.send(:text).text)
      end
    end
  end
end
