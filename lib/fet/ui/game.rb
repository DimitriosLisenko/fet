# frozen_string_literal: true

require "ruby2d"
require "tmpdir"
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

      attr_accessor :level, :score, :timer, :note_range, :tmp_directory,
                    :tempo, :number_of_degrees, :key_type, :next_on_correct, :limit_degrees

      def initialize(tempo:, degrees:, key_type:, next_on_correct:, limit_degrees: [])
        self.note_range = Fet::REDUCED_BY_OCTAVE_PIANO_RANGE
        self.tempo = tempo
        self.key_type = key_type
        self.number_of_degrees = degrees
        self.next_on_correct = next_on_correct
        self.limit_degrees = limit_degrees
        self.tmp_directory = Dir.mktmpdir
        initialize_ui_objects
        validate!
        setup_window
      end

      def start
        score.start
        level.start
        timer.start
        show_window
        Fet::ScoreSummary.add_entry(self)
      end

      def stop
        close_window
      end

      private

      def initialize_ui_objects
        self.score = Score.new(self)
        self.level = Level.new(self)
        self.timer = Timer.new(self)
      end

      def validate!
        validate_degrees!
      end

      def validate_degrees!
        return unless !limit_degrees.empty? && number_of_degrees > limit_degrees.uniq.size

        raise ArgumentError.new("Can not select #{number_of_degrees} degrees from set of #{limit_degrees}")
      end

      def show_window
        Ruby2D::Window.show
      end

      def close_window
        Ruby2D::Window.close
      end
    end
  end
end
