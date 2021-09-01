# frozen_string_literal: true

module Fet
  # Class in charge of generating chord progressions, as well as any associated music theory
  class ChordProgression
    TEMPLATE_MAJOR = "major".deep_freeze
    TEMPLATE_MINOR = "minor".deep_freeze

    DEFAULT_TEMPLATES = {
      # I-IV-V7-I
      TEMPLATE_MAJOR => [[0, 4, 7], [0, 5, 9], [-1, 5, 7], [0, 4, 7]],
      # i-iv-V7-i
      TEMPLATE_MINOR => [[0, 3, 7], [0, 5, 8], [-1, 5, 7], [0, 3, 7]],
    }.deep_freeze

    attr_accessor :template, :offset

    def initialize(offset:, template_type: nil, template: nil)
      self.template = template_type ? DEFAULT_TEMPLATES[template_type] : template
      validate_template!

      self.offset = offset
      validate_offset!
    end

    def with_offset
      return template.map { |chord| chord.map { |note| note + offset } }
    end

    private

    def validate_template!
      validate_nonempty_array!(template, template)
      template.each do |chord|
        validate_nonempty_array!(template, chord)
        chord.each do |offset|
          validate_integer!(template, offset)
        end
      end
    end

    def validate_offset!
      validate_integer!(offset, offset)
    end

    def validate_nonempty_array!(core, element)
      raise Fet::InvalidChordProgression.new(core) unless element.is_a?(Array)
      raise Fet::InvalidChordProgression.new(core) if element.empty?
    end

    def validate_integer!(core, element)
      raise Fet::InvalidChordProgression.new(core) unless element.is_a?(Integer)
    end
  end
end
