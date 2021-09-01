# frozen_string_literal: true

require "test_helper"

module Fet
  class ChordProgressionTest < Minitest::Test
    def test_major_chord_progression
      template = Fet::ChordProgression::DEFAULT_TEMPLATES[Fet::ChordProgression::TEMPLATE_MAJOR]
      major = Fet::ChordProgression.new(offset: 0, template_type: Fet::ChordProgression::TEMPLATE_MAJOR)
      assert_equal(template, major.with_offset)

      major = Fet::ChordProgression.new(offset: 10, template_type: Fet::ChordProgression::TEMPLATE_MAJOR)
      assert_equal(template.flatten.map { |x| x + 10 }, major.with_offset.flatten)
    end

    def test_minor_chord_progression
      template = Fet::ChordProgression::DEFAULT_TEMPLATES[Fet::ChordProgression::TEMPLATE_MINOR]
      minor = Fet::ChordProgression.new(offset: 0, template_type: Fet::ChordProgression::TEMPLATE_MINOR)
      assert_equal(template, minor.with_offset)

      minor = Fet::ChordProgression.new(offset: 10, template_type: Fet::ChordProgression::TEMPLATE_MINOR)
      assert_equal(template.flatten.map { |x| x + 10 }, minor.with_offset.flatten)
    end

    def test_invalid_chord_progression
      assert_raises(Fet::InvalidChordProgression) { Fet::ChordProgression.new(offset: "offset", template_type: Fet::ChordProgression::TEMPLATE_MINOR) }
      assert_raises(Fet::InvalidChordProgression) { Fet::ChordProgression.new(offset: 0, template_type: "hello") }
      assert_raises(Fet::InvalidChordProgression) { Fet::ChordProgression.new(offset: 0, template: ["hello", "world"]) }
      assert_raises(Fet::InvalidChordProgression) { Fet::ChordProgression.new(offset: 0, template: []) }
    end
  end
end
