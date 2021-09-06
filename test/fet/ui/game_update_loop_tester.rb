# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameUpdateLoopTester
      def test_timer_update_loop
        now = DateTime.now
        Timecop.freeze(now)
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)

        # NOTE: Timecop does not yet support freezing Process.clock_gettime
        timer = game.timer
        def timer.current_time
          return Time.now.to_i
        end

        game_instance_test(game) do
          Timecop.freeze(now + (10.0 / 24 / 60 / 60))
          game.handle_update_loop
          assert_equal(10, game.timer.seconds_elapsed)
        end
      end
    end
  end
end
