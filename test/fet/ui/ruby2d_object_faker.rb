# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    module Ruby2dObjectFaker
      private

      def stub_window_show
        Ruby2D::Window.stub(:show, nil) { yield }
      end

      def stub_window_close
        Ruby2D::Window.stub(:close, nil) { yield }
      end

      def stub_music_instance_play
        Ruby2D::Music.stub_any_instance(:play, nil) { yield }
      end

      def stub_text_initialize
        Ruby2D::Text.stub(:new, FakeText.method(:new)) { yield }
      end

      def stub_music_initialize
        Ruby2D::Music.stub(:new, FakeMusic.method(:new)) { yield }
      end

      def stub_ruby2d_objects
        stub_window_show { stub_window_close { stub_music_instance_play { stub_music_initialize { stub_text_initialize { yield } } } } }
      end

      # NOTE: this is required because it seems that at the moment even initializing the Ruby2D::Text object
      # starts up a Ruby process that I guess is supposed to be the UI, and makes GitHub actions fail with
      # Error: (SDL_Init) No available video device
      # NOTE: if this resolves the issue of the Ruby process starting, then maybe we can run the game in a thread for tests
      class FakeText
        attr_accessor :text, :color, :x, :y, :size, :font

        def initialize(text, **args)
          self.text = text
          self.color = args[:color]
          self.x = args[:x]
          self.y = args[:y]
          self.size = args[:size]
          self.font = args[:font]
        end
      end

      # NOTE: also load Ruby process as Ruby2D::Text
      class FakeMusic
        attr_accessor :path, :loop, :number_of_times_played

        def initialize(path)
          self.path = path
          self.number_of_times_played = 0
        end

        def play
          self.number_of_times_played += 1
        end
      end
    end
  end
end
