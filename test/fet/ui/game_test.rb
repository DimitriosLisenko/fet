# frozen_string_literal: true

require "test_helper"
require_relative "game_test_helper"

module Fet
  module Ui
    class GameTest < Minitest::Test
      include GameTestHelper

      def test_click_correct_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          correct_note_box = game.level.note_boxes.note_boxes.detect(&:correct?)
          assert_note_box_original_color(correct_note_box)
          click_note_box(game, correct_note_box)
          assert_note_box_correct_color(correct_note_box)
        end
      end

      def test_click_wrong_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          correct_note_box = correct_note_box(game)
          wrong_note_box = any_wrong_note_box(game)
          assert_note_box_original_color(correct_note_box)
          assert_note_box_original_color(wrong_note_box)
          click_note_box(game, wrong_note_box)
          assert_note_box_correct_color(correct_note_box)
          assert_note_box_wrong_color(wrong_note_box)
        end
      end
    end
  end
end
