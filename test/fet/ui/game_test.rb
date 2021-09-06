# frozen_string_literal: true

require "test_helper"
require_relative "game_test_helper"
require_relative "game_update_loop_test_helper"
require_relative "ruby2d_object_faker"

module Fet
  module Ui
    class GameTest < Minitest::Test
      include GameTestHelper
      include GameUpdateLoopTestHelper
      include Ruby2dObjectFaker

      def teardown
        Ruby2D::Window.clear
        Timecop.return
      end

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

      def test_return_goes_to_next_level
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert(1, game.level.question_number)
          press_key(game, "return")
          assert(1, game.level.question_number)
          select_wrong_note_with_tests(game, false)
          press_key(game, "return")
          assert(2, game.level.question_number)
        end
      end

      def test_c_plays_chord_progression
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert_difference(-> { game.level.send(:chord_progression_music).number_of_times_played }, 1) { press_key(game, "c") }
        end
      end

      def test_n_plays_notes
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert_difference(-> { game.level.send(:notes_music).number_of_times_played }, 1) { press_key(game, "n") }
        end
      end

      def test_l_plays_full_question_and_loops
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert_difference(-> { game.level.send(:full_question_music).number_of_times_played }, 1) do
            press_key(game, "l")
            assert_equal(true, game.level.send(:full_question_music).loop)
          end
        end
      end

      def test_invalid_degree_on_keyboard
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          # make sure this doesn't raise any exceptions
          press_key(game, "-")
          press_key(game, "1")
          assert(true, game.level.note_boxes.note_boxes.none?(&:selected))
        end
      end

      def assert_difference(value_lambda, difference)
        old_value = value_lambda.call
        yield
        new_value = value_lambda.call
        assert_equal(old_value + difference, new_value)
      end
    end
  end
end
