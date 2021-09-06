# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameMouseInputTester
      def test_click_correct_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          select_correct_note_with_tests(game, true)
        end
      end

      def test_right_click_does_nothing
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          correct_note_box = any_correct_note_box(game)
          assert_note_box_original_color(correct_note_box)
          click_note_box(game, correct_note_box, :right)
          assert_note_box_original_color(correct_note_box)
        end
      end

      def test_click_wrong_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "minor", next_on_correct: false)
        game_instance_test(game) do
          select_wrong_note_with_tests(game, true)
        end
      end

      def test_click_correct_note_with_next_on_correct
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: true)
        game_instance_test(game) do
          assert(1, game.level.question_number)
          correct_note_box = any_correct_note_box(game)
          assert_note_box_original_color(correct_note_box)
          click_note_box(game, correct_note_box)
          assert(2, game.level.question_number)
        end
      end

      def test_click_correct_note_two_degrees
        game = Fet::Ui::Game.new(tempo: 200, degrees: 2, key_type: "major", next_on_correct: true)
        game_instance_test(game) do
          select_correct_note_with_tests(game, true)
        end
      end

      def test_click_wrong_note_two_degrees
        game = Fet::Ui::Game.new(tempo: 200, degrees: 2, key_type: "major", next_on_correct: true)
        game_instance_test(game) do
          select_wrong_note_with_tests(game, true)
        end
      end

      def test_press_note_after_level_plays_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          select_correct_note_with_tests(game, false)
          correct_note_box = any_correct_note_box(game)
          assert_equal(0, correct_note_box.send(:note_music).number_of_times_played)
          assert_difference(-> { correct_note_box.send(:note_music).number_of_times_played }, 1) do
            click_note_box(game, correct_note_box)
          end
        end
      end
    end
  end
end
