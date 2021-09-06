# frozen_string_literal: true

require "test_helper"

module Fet
  class DegreeTest < Minitest::Test
    VALID_DEGREES = [
      [nil, "1"],
      ["#", "1"],
      ["b", "2"],
      [nil, "2"],
      ["#", "2"],
      ["b", "3"],
      [nil, "3"],
      [nil, "4"],
      ["#", "4"],
      ["b", "5"],
      [nil, "5"],
      ["#", "5"],
      ["b", "6"],
      [nil, "6"],
      ["#", "6"],
      ["b", "7"],
      [nil, "7"],
    ].deep_freeze

    DEGREE_TO_SEMITONE_OFFSET = {
      "1" => 0,
      "#1" => 1,
      "b2" => 1,
      "2" => 2,
      "#2" => 3,
      "b3" => 3,
      "3" => 4,
      "4" => 5,
      "#4" => 6,
      "b5" => 6,
      "5" => 7,
      "#5" => 8,
      "b6" => 8,
      "6" => 9,
      "#6" => 10,
      "b7" => 10,
      "7" => 11,
    }.deep_freeze

    def test_valid_degrees
      VALID_DEGREES.each do |accidental, degree_value|
        assert(Fet::Degree.new("#{accidental}#{degree_value}"))
      end
    end

    def test_invalid_degrees
      assert_raises(Fet::InvalidDegreeName) { Fet::Degree.new("bb3") }
      assert_raises(Fet::InvalidDegreeName) { Fet::Degree.new("x2") }
      assert_raises(Fet::InvalidDegreeName) { Fet::Degree.new("8") }
    end

    def test_degree_accidental
      VALID_DEGREES.each do |accidental, degree_value|
        if accidental
          assert_equal(accidental, Fet::Degree.new("#{accidental}#{degree_value}").degree_accidental)
        else
          assert_nil(Fet::Degree.new("#{accidental}#{degree_value}").degree_accidental)
        end
      end
    end

    def test_degree_value
      VALID_DEGREES.each do |accidental, degree_value|
        assert_equal(degree_value.to_i, Fet::Degree.new("#{accidental}#{degree_value}").degree_value)
      end
    end

    def test_degree_index
      DEGREE_TO_SEMITONE_OFFSET.each do |degree_name, semitone_offset|
        assert_equal(semitone_offset, Fet::Degree.new(degree_name).degree_index)
      end
    end
  end
end
