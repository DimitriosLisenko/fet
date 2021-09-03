# frozen_string_literal: true

require "ruby2d"
require_relative "color_scheme"

module Fet
  module Ui
    # Holds the correct/incorrect answers to questions for this session
    class Score
      attr_accessor :game, :text

      def initialize(game)
        self.game = game
        self.score = initialize_score
      end

      def start
        self.text = generate_text
      end

      def handle_event_loop(event); end

      def handle_update_loop; end

      def answer_correctly(degree_index)
        score[degree_index][:correct] += 1
      end

      def answer_incorrectly(degree_index)
        score[degree_index][:incorrect] += 1
      end

      def answered_correctly(degree_index = nil)
        return score.reduce(0) do |result, (score_degree_index, score_hash)|
          degree_index.nil? || score_degree_index == degree_index ? result + score_hash[:correct] : result
        end
      end

      def answered_incorrectly(degree_index = nil)
        return score.reduce(0) do |result, (score_degree_index, score_hash)|
          degree_index.nil? || score_degree_index == degree_index ? result + score_hash[:incorrect] : result
        end
      end

      def questions_asked(degree_index = nil)
        return answered_correctly(degree_index) + answered_incorrectly(degree_index)
      end

      private

      attr_accessor :score

      TEXT_SIZE = 36
      X_OFFSET = 508
      Y_OFFSET = 90
      private_constant :TEXT_SIZE, :X_OFFSET, :Y_OFFSET

      def initialize_score
        Fet::Degree::DEGREE_NAMES.map.with_index { |_, degree_index| [degree_index, { correct: 0, incorrect: 0 }] }.to_h
      end

      def text_value
        return "#{answered_correctly}/#{questions_asked}"
      end

      def generate_text
        return Ruby2D::Text.new(
          text_value,
          x: X_OFFSET, y: Y_OFFSET,
          font: "assets/fonts/PTSans/PTSans-Regular.ttf",
          size: TEXT_SIZE,
          color: ColorScheme::WHITE,
        )
      end
    end
  end
end
