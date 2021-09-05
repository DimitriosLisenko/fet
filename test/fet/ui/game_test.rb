# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    class GameTest < Minitest::Test
      def teardown
        Ruby2D::Window.clear
      end

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

      private

      def correct_note_box(game)
        return game.level.note_boxes.note_boxes.detect(&:correct?)
      end

      def any_wrong_note_box(game)
        return game.level.note_boxes.note_boxes.reject(&:correct?).first
      end

      def note_box_square(note_box)
        return note_box.send(:square)
      end

      def assert_note_box_original_color(note_box)
        degree = Degree.new(note_box.degree_name)
        if degree.degree_accidental.nil?
          assert_color_equal(Ruby2D::Color.new(Fet::Ui::ColorScheme::WHITE), note_box_square(note_box).color)
        else
          assert_color_equal(Ruby2D::Color.new(Fet::Ui::ColorScheme::GREY), note_box_square(note_box).color)
        end
      end

      def assert_note_box_correct_color(note_box)
        assert_color_equal(Ruby2D::Color.new(Fet::Ui::ColorScheme::GREEN), note_box_square(note_box).color)
      end

      def assert_note_box_wrong_color(note_box)
        assert_color_equal(Ruby2D::Color.new(Fet::Ui::ColorScheme::RED), note_box_square(note_box).color)
      end

      def click_note_box(game, note_box)
        click_event = Ruby2D::Window::MouseEvent.new(
          :down, :left, nil,
          note_box_square(note_box).x + (note_box_square(note_box).size / 2),
          note_box_square(note_box).y + (note_box_square(note_box).size / 2),
        )
        game.handle_event_loop(click_event)
      end

      def game_instance_test(game)
        with_stubs do
          game.start
          yield
          game.stop
        end
      end

      def with_stubs
        stub_window_show do
          stub_window_close do
            stub_music_instance_play do
              yield
            end
          end
        end
      end

      def stub_window_show
        Ruby2D::Window.stub(:show, nil) do
          yield
        end
      end

      def stub_window_close
        Ruby2D::Window.stub(:close, nil) do
          yield
        end
      end

      def stub_music_instance_play
        Ruby2D::Music.stub_any_instance(:play, nil) do
          yield
        end
      end

      def assert_color_equal(expected, actual)
        assert_in_delta(expected.r, actual.r)
        assert_in_delta(expected.g, actual.g)
        assert_in_delta(expected.b, actual.b)
        assert_in_delta(expected.a, actual.a)
      end
    end
  end
end
