module Fet
  module HardcodedScales
    MAJOR_SCALES = [
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

    DEGREES_OF_MODE = {
      ["lydian"] => ["1", "2", "3", "#4", "5", "6", "7"],
      ["major", "ionian"] => ["1", "2", "3", "4", "5", "6", "7"],
      ["mixolydian"] => ["1", "2", "3", "4", "5", "6", "b7"],
      ["dorian"] => ["1", "2", "b3", "4", "5", "6", "b7"],
      ["minor", "aeolian"] => ["1", "2", "b3", "4", "5", "b6", "b7"],
      ["phrygian"] => ["1", "b2", "b3", "4", "5", "b6", "b7"],
      ["locrian"] => ["1", "b2", "b3", "4", "b5", "b6", "b7"],
    }.deep_freeze
    private_constant :DEGREES_OF_MODE

    def hardcoded_scales(mode_name)
      rotation = ROTATION_FOR_MODE.detect { |mode_names, _| mode_names.include?(mode_name) }[1]
      return MAJOR_SCALES.map { |major_scale| major_scale.rotate(rotation) }
    end

    def degrees_of_mode(mode_name)
      return DEGREES_OF_MODE.detect { |mode_names, _| mode_names.include?(mode_name) }[1]
    end
  end
end
