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
          select_correct_note_with_tests(game, true)
        end
      end

      def test_click_wrong_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "minor", next_on_correct: false)
        game_instance_test(game) do
          select_wrong_note_with_tests(game, true)
        end
      end

      def test_keyboard_select_correct_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          select_correct_note_with_tests(game, false)
        end
      end

      def test_keyboard_select_wrong_note
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          select_wrong_note_with_tests(game, false)
        end
      end

      def test_enter_goes_to_next_level
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert(1, game.level.question_number)
          press_key(game, "enter")
          assert(1, game.level.question_number)
          select_wrong_note_with_tests(game, false)
          press_key(game, "enter")
          assert(2, game.level.question_number)
        end
      end
    end
  end
end