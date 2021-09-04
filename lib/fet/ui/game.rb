# frozen_string_literal: true

require "ruby2d"
require_relative "game_loop_handler"
require_relative "game_setup_helper"
require_relative "level"
require_relative "score"
require_relative "timer"

module Fet
  module Ui
    # Holds the state of the current game
    class Game
      include GameSetupHelper
      include GameLoopHandler

      attr_accessor :level, :score, :timer, :note_range,
                    :tempo, :number_of_degrees, :key_type, :next_on_correct

      def initialize(tempo:, degrees:, key_type:, next_on_correct: true)
        self.note_range = Fet::REDUCED_BY_OCTAVE_PIANO_RANGE
        self.tempo = tempo
        self.key_type = key_type
        self.number_of_degrees = degrees
        self.next_on_correct = next_on_correct
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
    end
  end
end
