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

    MINOR_SCALES = [
      ["G#", "A#", "B", "C#", "D#", "E", "F#"],
      ["C#", "D#", "E", "F#", "G#", "A", "B"],
      ["F#", "G#", "A", "B", "C#", "D", "E"],
      ["B", "C#", "D", "E", "F#", "G", "A"],
      ["E", "F#", "G", "A", "B", "C", "D"],
      ["A", "B", "C", "D", "E", "F", "G"],
      ["D", "E", "F", "G", "A", "Bb", "C"],
      ["G", "A", "Bb", "C", "D", "Eb", "F"],
      ["C", "D", "Eb", "F", "G", "Ab", "Bb"],
      ["F", "G", "Ab", "Bb", "C", "Db", "Eb"],
      ["Bb", "C", "Db", "Eb", "F", "Gb", "Ab"],
      ["Eb", "F", "Gb", "Ab", "Bb", "Cb", "Db"],
    ].deep_freeze
  end
end
