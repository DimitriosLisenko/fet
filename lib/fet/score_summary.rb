# frozen_string_literal: true

require "date"
require "json"
require "terminal-table"
require_relative "score_summary_writer"

module Fet
  # Responsible for writing + showing the score summary to the user
  class ScoreSummary
    extend ScoreSummaryWriter

    NO_SCORES_MESSAGE = "No scores available yet!".deep_freeze

    def initialize(minimum_session_length: 0, number_of_degrees: nil, key_type: nil, begin_offset: 0, end_offset: 0)
      self.minimum_session_length = minimum_session_length
      self.number_of_degrees = number_of_degrees
      self.key_type = key_type
      self.begin_offset = begin_offset
      self.end_offset = end_offset
    end

    def summary
      if file_exists?
        percentage_summary
      else
        puts NO_SCORES_MESSAGE
      end
    end

    private

    attr_accessor :minimum_session_length, :number_of_degrees, :key_type, :begin_offset, :end_offset

    def filename
      return self.class.scores_filename
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
      result = games_array
      result = filter_by_seconds_elapsed(result)
      result = filter_by_number_of_degrees(result)
      result = filter_by_key_type(result)
      result = filter_by_offsets(result)
      return result
    end

    def filter_by_seconds_elapsed(games_array)
      return games_array.select { |game_details| game_details["seconds_elapsed"] >= minimum_session_length }
    end

    def filter_by_number_of_degrees(games_array)
      return games_array if number_of_degrees.nil?

      return games_array.select { |game_details| game_details["number_of_degrees"] == number_of_degrees }
    end

    def filter_by_key_type(games_array)
      return games_array if key_type.nil?

      return games_array.select { |game_details| game_details["key_type"] == key_type }
    end

    def filter_by_offsets(games_array)
      begin_index = 0
      end_index = games_array.size
      return games_array[(begin_index + begin_offset)...(end_index + end_offset)] || []
    end

    def score_instances
      return games_array_with_constraints.map { |game_details| Fet::Score.new(score: game_details["score"]) }
    end

    def merged_score_instance
      return Fet::Score.merge(*score_instances)
    end

    def generate_table(score_instance)
      Terminal::Table.new do |t|
        generate_table_header(t)
        t.add_separator
        generate_table_main(t, score_instance)
        t.add_separator
        generate_table_footer(t, score_instance)
      end
    end

    def generate_table_header(table)
      table.add_row(["Degree", "Answered Correctly", "Total Answered", "Percentage"])
    end

    def generate_table_main(table, score_instance)
      score_instance.percentages.each do |degree_index, percentage|
        table.add_row(
          [
            Fet::Degree::DEGREE_NAMES[degree_index].last,
            score_instance.answered_correctly(degree_index),
            score_instance.questions_asked(degree_index),
            "#{percentage}%",
          ],
        )
      end
    end

    def generate_table_footer(table, score_instance)
      table.add_row(
        [
          "All",
          score_instance.answered_correctly,
          score_instance.questions_asked,
          "#{score_instance.total_percentage}%",
        ],
      )
    end

    def percentage_summary
      table = generate_table(merged_score_instance)
      puts table
    end
  end
end
