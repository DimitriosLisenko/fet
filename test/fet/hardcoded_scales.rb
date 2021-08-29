# frozen_string_literal: true

module Fet
  module HardcodedScales
    MAJOR_SCALES = [
      ["C#", "D#", "E#", "F#", "G#", "A#", "B#"],
      ["F#", "G#", "A#", "B", "C#", "D#", "E#"],
      ["B", "C#", "D#", "E", "F#", "G#", "A#"],
      ["E", "F#", "G#", "A", "B", "C#", "D#"],
      ["A", "B", "C#", "D", "E", "F#", "G#"],
      ["D", "E", "F#", "G", "A", "B", "C#"],
      ["G", "A", "B", "C", "D", "E", "F#"],
      ["C", "D", "E", "F", "G", "A", "B"],
      ["F", "G", "A", "Bb", "C", "D", "E"],
      ["Bb", "C", "D", "Eb", "F", "G", "A"],
      ["Eb", "F", "G", "Ab", "Bb", "C", "D"],
      ["Ab", "Bb", "C", "Db", "Eb", "F", "G"],
      ["Db", "Eb", "F", "Gb", "Ab", "Bb", "C"],
      ["Gb", "Ab", "Bb", "Cb", "Db", "Eb", "F"],
      ["Cb", "Db", "Eb", "Fb", "Gb", "Ab", "Bb"],
    ].deep_freeze
    private_constant :MAJOR_SCALES

    ROTATION_FOR_MODE = {
      ["major", "ionian"] => 0,
      ["dorian"] => 1,
      ["phrygian"] => 2,
      ["lydian"] => 3,
      ["mixolydian"] => 4,
      ["minor", "aeolian"] => 5,
      ["locrian"] => 6,
    }.deep_freeze
    private_constant :ROTATION_FOR_MODE

    def hardcoded_scales(mode_name)
      rotation = ROTATION_FOR_MODE.detect { |mode_names, _| mode_names.include?(mode_name) }[1]
      return MAJOR_SCALES.map { |major_scale| major_scale.rotate(rotation) }
    end
  end
end
