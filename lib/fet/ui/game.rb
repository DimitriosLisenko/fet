# frozen_string_literal: true

require "ruby2d"
require_relative "game_loop_handler"
require_relative "game_setup_helper"
require_relative "level"
require_relative "score"

module Fet
  module Ui
    # Holds the state of the current game
    class Game
      include GameSetupHelper
      include GameLoopHandler

      attr_accessor :level, :score, :timer

      def initialize
        self.score = Score.new(self)
        self.level = Level.new(self)
        self.timer = Timer.new(self)
        setup_window
      end

      def start
        timer.start
        Ruby2D::Window.show
      end

      def next_level
        self.level = Level.new(self)
      end
    end
  end
end
