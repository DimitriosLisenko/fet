# frozen_string_literal: true

module Fet
  # Holds the correct/incorrect answers to questions for this session
  class Score
    def initialize
      self.score = initialize_score
    end

    def answer_correctly(degree)
      key = keys.detect { |k| k.include?(degree) }
      score[key][:correct] += 1
    end

    def answer_incorrectly(degree)
      key = keys.detect { |k| k.include?(degree) }
      score[key][:incorrect] += 1
    end

    def answered_correctly(degree = nil)
      return score.reduce(0) do |result, (degree_names, score_hash)|
        degree.nil? || degree_names.include?(degree) ? result + score_hash[:correct] : result
      end
    end

    def answered_incorrectly(degree = nil)
      return score.reduce(0) do |result, (degree_names, score_hash)|
        degree.nil? || degree_names.include?(degree) ? result + score_hash[:incorrect] : result
      end
    end

    def questions_asked(degree = nil)
      return answered_correctly(degree) + answered_incorrectly(degree)
    end

    private

    attr_accessor :score

    def initialize_score
      Fet::Degree::DEGREE_NAMES.map { |degree_names| [degree_names, { correct: 0, incorrect: 0 }] }.to_h
    end
  end
end
