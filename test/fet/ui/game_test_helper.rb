# frozen_string_literal: true

require "test_helper"
require_relative "ruby2d_object_faker"
require_relative "note_box_asserts"

module Fet
  module Ui
    module GameTestHelper
      include NoteBoxAsserts
      include Ruby2dObjectFaker

      private

      def select_correct_note_with_tests(game, select_using_mouse)
        correct_note_boxes = correct_note_boxes(game)
        correct_note_boxes.each { |note_box| assert_note_box_original_color(note_box) }

        correct_selection_game_tests(game, correct_note_boxes.size == 1) do
          select_note_box(game, correct_note_boxes.first, select_using_mouse)
        end

        assert_note_box_correct_color(correct_note_boxes.first)
        correct_note_boxes[1..].each { |note_box| assert_note_box_original_color(note_box) }
      end

      def select_wrong_note_with_tests(game, select_using_mouse)
        correct_note_boxes = correct_note_boxes(game)
        wrong_note_box = any_wrong_note_box(game)

        correct_note_boxes.each { |note_box| assert_note_box_original_color(note_box) }
        assert_note_box_original_color(wrong_note_box)

        wrong_selection_game_tests(game) do
          select_note_box(game, wrong_note_box, select_using_mouse)
        end

        correct_note_boxes.each { |note_box| assert_note_box_correct_color(note_box) }
        assert_note_box_wrong_color(wrong_note_box)
      end

      def correct_selection_game_tests(game, single_correct_note)
        assert(!game.level.over?)
        assert_equal("0/1", game.score.send(:text).text)
        yield
        score = single_correct_note ? "1/1" : "0/1"
        assert_equal(single_correct_note, game.level.over?)
        assert_equal(score, game.score.send(:text).text)
      end

      def wrong_selection_game_tests(game)
        assert(!game.level.over?)
        assert_equal("0/1", game.score.send(:text).text)
        yield
        assert(game.level.over?)
        assert_equal("0/1", game.score.send(:text).text)
      end

      def select_note_box(game, note_box, select_using_mouse)
        select_using_mouse ? click_note_box(game, note_box) : keyboard_select_note_box(game, note_box)
      end

      def correct_note_boxes(game)
        return game.level.note_boxes.note_boxes.select(&:correct?)
      end

      def any_correct_note_box(game)
        return correct_note_boxes(game).first
      end

      def any_wrong_note_box(game)
        return game.level.note_boxes.note_boxes.reject(&:correct?).first
      end

      def note_box_square(note_box)
        return note_box.send(:square)
      end

      def click_note_box(game, note_box, click_button = :left)
        [:down, :up].each do |click_type|
          click_event = Ruby2D::Window::MouseEvent.new(
            click_type, click_button, nil,
            note_box_square(note_box).x + (note_box_square(note_box).size / 2),
            note_box_square(note_box).y + (note_box_square(note_box).size / 2),
          )
          game.handle_event_loop(click_event)
        end
      end

      def keyboard_select_note_box(game, note_box)
        degree_name_to_button_presses(note_box.degree_name).each { |key| press_key(game, key) }
      end

      def press_key(game, key)
        [:down, :up].each do |key_type|
          key_event = Ruby2D::Window::KeyEvent.new(key_type, key)
          game.handle_event_loop(key_event)
        end
      end

      def game_instance_test(game)
        with_game_stubs do
          game.start
          yield
          game.stop
        end
      end

      def with_game_stubs
        stub_ruby2d_objects { stub_our_objects { yield } }
      end

      def stub_our_objects
        stub_scores_filename { yield }
      end

      def stub_scores_filename
        # NOTE: in order to make this work correctly, need to make sure that
        # the stub for Ruby2D::Window stays running until it receives a signal. However,
        # Ruby2D really doesn't like being called from a thread (throws random exceptions),
        # so might have to run the test inside a thread + use Queue.new for sync?
        Fet::ScoreSummary.stub(:scores_filename, File.join(tmp_directory, "scores")) { yield }
      end

      # NOTE: there may be no keys generated this test run with accidentals, so exclude from coverage
      # :nocov:
      def degree_name_to_button_presses(degree_name)
        degree = Degree.new(degree_name)

        result = []
        result << "-" if degree.degree_accidental
        result << degree.degree_value.to_s
        return result
      end
      # :nocov:
    end
  end
end
