# frozen_string_literal: true

require "json"

module Fet
  # Holds the correct/incorrect answers to questions
  class Score
    def initialize(score: nil)
      score_hash = score || initialize_score
      score_hash = score_hash.map do |k, v|
        [k.to_i, v.transform_keys(&:to_sym)]
      end.to_h
      self.score = score_hash
    end

    def self.merge(*scores)
      scores.each_with_object(Fet::Score.new) { |x, res| res.merge(x) }
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

    def merge(other)
      score.each do |k, v|
        v[:correct] += other.answered_correctly(k)
        v[:incorrect] += other.answered_incorrectly(k)
      end
    end

    def percentages
      score.map do |k, _|
        next([k, percentage(answered_correctly(k), questions_asked(k)).to_i])
      end.to_h
    end

    def total_percentage
      return percentage(answered_correctly, questions_asked).to_i
    end

    protected

    attr_accessor :score

    private

    def initialize_score
      Fet::Degree::DEGREE_NAMES.map.with_index { |_, degree_index| [degree_index, { correct: 0, incorrect: 0 }] }.to_h
    end

    def percentage(correct, total)
      return 0.0 if total.zero?

      return correct.fdiv(total) * 100
    end
  end
end
