# frozen_string_literal: true

require "date"
require "json"
require "terminal-table"
require_relative "score_summary_writer"

module Fet
  # Responsible for writing + showing the score summary to the user
  class ScoreSummary
    extend ScoreSummaryWriter

    def initialize(minimum_session_length: 0, date_from: nil, date_until: nil, last: nil)
      self.minimum_session_length = minimum_session_length
      self.date_from = date_from.nil? ? date_from : DateTime.parse(date_from)
      self.date_until = date_until.nil? ? DateTime.now.new_offset(0) : DateTime.parse(date_until)
      self.last = last
    end

    def summary
      puts "No scores available yet!" and return unless file_exists?

      percentage_summary
    end

    private

    attr_accessor :minimum_session_length, :date_from, :date_until, :last

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
      result = filter_by_last(result)
      result = filter_by_date_from(result)
      result = filter_by_date_until(result)
      return result
    end

    def filter_by_last(games_array)
      return games_array if last.nil?

      return games_array.last(last)
    end

    def filter_by_seconds_elapsed(games_array)
      return games_array.select { |game_details| game_details["seconds_elapsed"] > minimum_session_length }
    end

    def filter_by_date_from(games_array)
      return games_array if date_from.nil?

      return games_array.select { |game_details| DateTime.parse(game_details["started_at"]) >= date_from }
    end

    def filter_by_date_until(games_array)
      return games_array.select { |game_details| DateTime.parse(game_details["started_at"]) <= date_until }
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
