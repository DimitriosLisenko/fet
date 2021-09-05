# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    class GameTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_start_game
        with_stubs do
          game = Fet::Ui::Game.new(tempo: 200, degrees: 1, key_type: "major", next_on_correct: false)
          game.start
        end
      end

      private

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
        # TODO: instead of nil pass a callable object so that it waits until we explicitly continue
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

      #   fiber = Fiber.new do
      #     Fiber.yield(game.start)
      #     Fiber.yield("Waiting for game completion...")
      #   end
      #   # TODO: actually the mock method is the one to be in a fiber...

      #   fiber.resume

      #   yield

      #   game.stop
      # end
    end
  end
end
