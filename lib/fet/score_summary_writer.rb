# frozen_string_literal: true

require "date"
require "json"
require "terminal-table"

module Fet
  # Methods for writing game score to file
  module ScoreSummaryWriter
    SCORES_FILENAME = "#{ENV["HOME"]}/.config/fet/scores".deep_freeze

    # NOTE: this is explicitly changed in tests, so no need to check for coverage
    # :nocov:
    def scores_filename
      return SCORES_FILENAME
    end
    # :nocov:

    def add_entry(game)
      write_score_to_file(game)
    end

    private

    def write_score_to_file(game)
      new_score_entries = historic_score_entries
      new_score_entries << current_score_entry(game)
      directory_name = File.dirname(scores_filename)
      FileUtils.mkdir_p(directory_name)
      File.open(scores_filename, "w") { |file| file.write(new_score_entries.to_json) }
    end

    def historic_score_entries
      result = File.read(scores_filename)
      return JSON.parse(result)
    rescue Errno::ENOENT
      return []
    end

    def current_score_entry(game)
      return {
        "started_at" => game.timer.started_at.to_s,
        "seconds_elapsed" => game.timer.seconds_elapsed,
        "number_of_degrees" => game.config.number_of_degrees,
        "tempo" => game.config.tempo,
        "key_type" => game.config.key_type,
        "score" => game.score.score,
      }
    end
  end
end
