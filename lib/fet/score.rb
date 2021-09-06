# frozen_string_literal: true

require "json"

module Fet
  # Holds the correct/incorrect answers to questions
  class Score
    def initialize
      self.score = initialize_score
    end

    def answer_correctly(*degree_indices)
      degree_indices.each { |degree_index| score[degree_index][:correct] += 1 }
    end

    def answer_incorrectly(*degree_indices)
      degree_indices.each { |degree_index| score[degree_index][:incorrect] += 1 }
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

    def as_json(_options = {})
      score
    end

    def to_json(*options)
      as_json(*options).to_json(*options)
    end

    private

    attr_accessor :score

    def initialize_score
      Fet::Degree::DEGREE_NAMES.map.with_index { |_, degree_index| [degree_index, { correct: 0, incorrect: 0 }] }.to_h
    end
  end
end
