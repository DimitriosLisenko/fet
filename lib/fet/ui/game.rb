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

      SCORES_FILENAME = "#{ENV["HOME"]}/.config/fet/scores".deep_freeze

      attr_accessor :level, :score, :timer, :note_range,
                    :tempo, :number_of_degrees, :key_type, :next_on_correct, :limit_degrees

      # NOTE: this is explicitly changed in tests, so no need to check for coverage
      # :nocov:
      def self.scores_filename
        return SCORES_FILENAME
      end
      # :nocov:

      def initialize(tempo:, degrees:, key_type:, next_on_correct:, limit_degrees: [])
        self.note_range = Fet::REDUCED_BY_OCTAVE_PIANO_RANGE
        self.tempo = tempo
        self.key_type = key_type
        self.number_of_degrees = degrees
        self.next_on_correct = next_on_correct
        self.limit_degrees = limit_degrees
        initialize_ui_objects
        validate!
        setup_window
      end

      def start
        score.start
        level.start
        timer.start
        show_window
        write_score_to_file
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

      def write_score_to_file
        new_score_entries = historic_score_entries
        new_score_entries << current_score_entry
        directory_name = File.dirname(self.class.scores_filename)
        FileUtils.mkdir_p(directory_name)
        File.open(self.class.scores_filename, "w") { |file| file.write(new_score_entries.to_json) }
      end

      def historic_score_entries
        result = File.read(self.class.scores_filename)
        return JSON.parse(result)
      rescue Errno::ENOENT
        return []
      end

      def current_score_entry
        return {
          "started_at" => timer.started_at.to_s,
          "seconds_elapsed" => timer.seconds_elapsed,
          "number_of_degrees" => number_of_degrees,
          "tempo" => tempo,
          "key_type" => key_type,
          "score" => score.score,
        }
      end
    end
  end
end
