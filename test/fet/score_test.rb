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

    def test_score_merge
      merged_score = Fet::Score.merge(predefined_score_object, another_predefined_score_object)
      assert_equal(2, merged_score.answered_correctly(2))
      assert_equal(2, merged_score.answered_incorrectly(2))
      assert_equal(6, merged_score.answered_correctly)
      assert_equal(4, merged_score.answered_incorrectly)
      assert_equal(10, merged_score.questions_asked)
    end

    def test_percentages
      score = another_predefined_score_object
      percentages = score.percentages
      assert_equal(0, percentages[degree_index("1")])
      assert_equal(0, percentages[degree_index("2")])
      assert_equal(50, percentages[degree_index("b3")])
      assert_equal(100, percentages[degree_index("b6")])
    end

    def test_total_percentage
      score = another_predefined_score_object
      assert_equal(60, score.total_percentage)
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

    def another_predefined_score_object
      score = Fet::Score.new
      score.answer_correctly(Degree.new("b3").degree_index, Degree.new("b5").degree_index, Degree.new("b6").degree_index)
      score.answer_incorrectly(Degree.new("b3").degree_index, Degree.new("2").degree_index)
      return score
    end
  end
end
