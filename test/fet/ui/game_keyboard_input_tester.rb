# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameKeyboardInputTester
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
          assert_difference(lambda { game.level.send(:chord_progression_music).number_of_times_played }, 1) { press_key(game, "c") }
        end
      end

      def test_n_plays_notes
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert_difference(lambda { game.level.send(:notes_music).number_of_times_played }, 1) { press_key(game, "n") }
        end
      end

      def test_l_plays_full_question_and_loops
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          assert_difference(lambda { game.level.send(:full_question_music).number_of_times_played }, 1) do
            press_key(game, "l")
            assert_equal(true, game.level.send(:full_question_music).loop)
          end
        end
      end

      def test_q_quits_application
        game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
        game_instance_test(game) do
          mocked_method = MiniTest::Mock.new
          mocked_method.expect :call, nil, []
          game.stub :stop, mocked_method do
            press_key(game, "q")
          end
          mocked_method.verify
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
    end
  end
end
