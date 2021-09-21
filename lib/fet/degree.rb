# frozen_string_literal: true

module Fet
  # This class handles validation of degree names and extraction of values from it
  class Degree
    DEGREE_NAMES = [
      ["1"],
      ["#1", "b2"],
      ["2"],
      ["#2", "b3"],
      ["3"],
      ["4"],
      ["#4", "b5"],
      ["5"],
      ["#5", "b6"],
      ["6"],
      ["#6", "b7"],
      ["7"],
    ].deep_freeze

    attr_reader :degree_name

    def initialize(degree_name)
      self.degree_name = degree_name
      validate_degree_name!
    end

    def self.from_degree_index(degree_index, accidental_type:)
      degree_names = DEGREE_NAMES[degree_index]
      degree_name = if degree_names.size == 1
                      degree_names[0]
                    else
                      case accidental_type
                      when "#"
                        degree_names[0]
                      when "b"
                        degree_names[1]
                      end
                    end
      return new(degree_name)
    end

    def degree_accidental
      return degree_name.size == 2 ? degree_name[0] : nil
    end

    def degree_value
      return degree_name.size == 2 ? degree_name[1].to_i : degree_name[0].to_i
    end

    def degree_index
      return DEGREE_NAMES.index { |degree_names| degree_names.include?(degree_name) }
    end

    private

    attr_writer :degree_name

    def validate_degree_name!
      raise InvalidDegreeName.new(degree_name) unless DEGREE_NAMES.flatten.include?(degree_name)
    end
  end
end
