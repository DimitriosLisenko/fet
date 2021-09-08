# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameDegreeLimitTester
      def test_degree_limits
        Fet::Degree::DEGREE_NAMES.flatten.each do |degree_name|
          game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false, limit_degrees: [degree_name])
          game_instance_test(game) do
            assert_equal(Degree.new(degree_name).degree_index, any_correct_note_box(game).degree_index)
          end
        end
      end
    end
  end
end
