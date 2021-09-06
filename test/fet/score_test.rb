# frozen_string_literal: true

require "test_helper"

module Fet
  class DegreeTest < Minitest::Test
    def test_score_changes
      score = predefined_score_object

      assert_equal(score.answered_correctly(Degree.new("2").degree_index), 2)
      assert_equal(score.answered_incorrectly(Degree.new("2").degree_index), 1)
      assert_equal(score.answered_correctly, 3)
      assert_equal(score.answered_incorrectly, 2)
      assert_equal(score.questions_asked, 5)
    end

    def test_score_as_json
      score = predefined_score_object
      json_hash = JSON.parse(score.to_json)
      assert(json_hash)
      assert(json_hash[degree_index("2").to_s])
      assert_equal(2, json_hash[degree_index("2").to_s]["correct"])
    end

    private

    def degree_index(degree_name)
      return Degree.new(degree_name).degree_index
    end

    def predefined_score_object
      score = Fet::Score.new
      score.answer_correctly(Degree.new("2").degree_index, Degree.new("2").degree_index, Degree.new("3").degree_index)
      score.answer_incorrectly(Degree.new("2").degree_index, Degree.new("5").degree_index)
      return score
    end
  end
end
