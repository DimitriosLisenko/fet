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

      attr_accessor :level, :score, :timer, :note_range,
                    :tempo, :number_of_degrees, :key_type

      def initialize
        self.note_range = Fet::REDUCED_BY_OCTAVE_PIANO_RANGE
        self.tempo = 200
        self.key_type = "major"
        self.number_of_degrees = 1
        self.score = Score.new(self)
        self.level = Level.new(self)
        self.timer = Timer.new(self)
        setup_window
      end

      def start
        score.start
        level.start
        timer.start
        Ruby2D::Window.show
      end

      def next_level
        self.level = Level.new(self)
      end
    end
  end
end