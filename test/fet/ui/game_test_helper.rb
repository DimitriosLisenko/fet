# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module GameTestHelper
      def teardown
        Ruby2D::Window.clear
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
              stub_score_writing do
                yield
              end
            end
          end
        end
      end

      def stub_window_show
        Ruby2D::Window.stub(:show, nil) { yield }
      end

      def stub_window_close
        Ruby2D::Window.stub(:close, nil) { yield }
      end

      def stub_music_instance_play
        Ruby2D::Music.stub_any_instance(:play, nil) { yield }
      end

      def stub_score_writing
        # NOTE: in order to make this work correctly, need to make sure that
        # the stub for Ruby2D::Window stays running until it receives a signal. However,
        # Ruby2D really doesn't like being called from a thread (throws random exceptions),
        # so might have to run the test inside a thread + use Queue.new for sync?
        Fet::Ui::Game.stub_any_instance(:write_score_to_file, nil) { yield }
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
