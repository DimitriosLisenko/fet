# frozen_string_literal: true

require "date"
require "json"

module Fet
  # Responsible for showing the score summary to the user
  class ScoreSummary
    def initialize(minimum_session_length: 0, date_from: nil, date_until: nil)
      self.minimum_session_length = minimum_session_length
      self.date_from = date_from.nil? ? date_from : DateTime.parse(date_from)
      self.date_until = date_until.nil? ? DateTime.now.new_offset(0) : DateTime.parse(date_until)
    end

    def summary
      puts "No scores available yet!" and return unless file_exists?

      percentage_summary
    end

    private

    attr_accessor :minimum_session_length, :date_from, :date_until

    def filename
      return Fet::Ui::Game.scores_filename
    end

    def file_exists?
      return File.exist?(filename)
    end

    def file_contents
      return File.read(filename)
    end

    def games_array
      return JSON.parse(file_contents)
    end

    def games_array_with_constraints
      result = games_array.select { |game_details| game_details["seconds_elapsed"] > minimum_session_length }
      result = result.select { |game_details| DateTime.parse(game_details["started_at"]) >= date_from } unless date_from.nil?
      result = result.select { |game_details| DateTime.parse(game_details["started_at"]) <= date_until }
      return result
    end

    def score_instances
      return games_array_with_constraints.map { |game_details| Fet::Score.new(score: game_details["score"]) }
    end

    def merged_score_instance
      return Fet::Score.merge(*score_instances)
    end

    def percentage_summary
      score_instance = merged_score_instance
      score_instance.percentages.each do |degree_index, percentage|
        puts "#{Fet::Degree::DEGREE_NAMES[degree_index].last}\t#{percentage}"
      end
      puts "Total\t#{score_instance.total_percentage}"
    end
  end
end
