#!/usr/bin/env ruby

require "fileutils"
require "./midi.rb"

# All 12 degrees
DEGREES = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "b6", "6", "b7", "7"]

# All keys. First element is 5 sharps, 4 sharps, ... 0 sharps/flats, 1 flat, ... all the way up to 6 flats.
# No 6 sharps because the 6 flat versions are enharmonic and more common.
# These keys chosen because they contain only flats and sharps, no double flats/sharps.
MAJOR_KEYS = ["B", "E", "A", "D", "G", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb"]
MINOR_KEYS = ["G#", "C#", "F#", "B", "E", "A", "D", "G", "C", "F", "Bb", "Eb"]

# In midilib, 0 is C(-2).
MIDI_VALUE_C0 = 24
MIDI_VALUE_C1 = 36
MIDI_VALUE_C2 = 48
MIDI_VALUE_C3 = 60
MIDI_VALUE_C4 = 72
MIDI_VALUE_C5 = 84
MIDI_VALUE_C6 = 96
MIDI_VALUE_C7 = 108
MIDI_VALUE_C8 = 120

MIDI_VALUE_ADDITION_C = 0
MIDI_VALUE_ADDITION_C_SHARP = 1
MIDI_VALUE_ADDITION_D_FLAT = 1
MIDI_VALUE_ADDITION_D = 2
MIDI_VALUE_ADDITION_D_SHARP = 3
MIDI_VALUE_ADDITION_E_FLAT = 3
MIDI_VALUE_ADDITION_E = 4
MIDI_VALUE_ADDITION_F = 5
MIDI_VALUE_ADDITION_F_SHARP = 6
MIDI_VALUE_ADDITION_G_FLAT = 6
MIDI_VALUE_ADDITION_G = 7
MIDI_VALUE_ADDITION_G_SHARP = 8
MIDI_VALUE_ADDITION_A_FLAT = 8
MIDI_VALUE_ADDITION_A = 9
MIDI_VALUE_ADDITION_A_SHARP = 10
MIDI_VALUE_ADDITION_B_FLAT = 10
MIDI_VALUE_ADDITION_B = 11

# Maps root note to MIDI value
MAJOR_KEY_ROOT_NOTE = {
  "B" => 47,
  "E" => 40,
  "A" => 45,
  "D" => 50,
  "G" => 43,
  "C" => 48,
  "F" => 41,
  "Bb" => 46,
  "Eb" => 51,
  "Ab" => 44,
  "Db" => 49,
  "Gb" => 42
}
MAJOR_KEY_ROOT_NOTE.each { |k, v| MAJOR_KEY_ROOT_NOTE[k] = v + 12 } # Octave higher sounds better
MINOR_KEY_ROOT_NOTE = MINOR_KEYS.zip(MAJOR_KEY_ROOT_NOTE.values.map { |i| i - 3 }).to_h


MAJOR_PROGRESSION = [[0, 4, 7], [0, 5, 9], [-1, 5, 7], [0, 4, 7]]
MINOR_PROGRESSION = [[0, 3, 7], [0, 5, 8], [-1, 5, 7], [0, 3, 7]]

VOCAL_RANGE_FOR_SINGING_EXERCISES = (MIDI_VALUE_C3..(MIDI_VALUE_C3 + MIDI_VALUE_ADDITION_B)) # C3 - B3 - needs to be one octave

def main
  tempo = ARGV[0].to_i
  if !(40..250).to_a.include?(tempo)
    puts "Usage: ruby generate_singing_exercises.rb {tempo} {sleep_duration}"
    puts "Please enter tempo from 40 to 250 inclusive"
    return
  end
  sleep_duration = ARGV[1].to_i
  if !(1..60).to_a.include?(sleep_duration)
    puts "Usage: ruby generate_singing_exercises.rb {tempo} {sleep_duration}"
    puts "Please enter a sleep duration (seconds) from 1 and 60 inclusive"
    return
  end

  MAJOR_KEYS.each do |key|
    root_note = MAJOR_KEY_ROOT_NOTE[key]
    VOCAL_RANGE_FOR_SINGING_EXERCISES.each do |target_note|
      degree = (target_note - root_note) % 12
      FileUtils.mkdir_p("singing/major")
      progression = MAJOR_PROGRESSION.map { |chord| chord.map { |note| note + root_note } }
      file_name = "./singing/major/#{key}M_#{DEGREES[degree]}.mid"
      info = "Key: #{key} major Degrees: #{DEGREES[degree]}"
      create_singing_midi_file(tempo, progression, target_note, sleep_duration, info, file_name)
    end
  end

  MINOR_KEYS.each do |key|
    root_note = MINOR_KEY_ROOT_NOTE[key]
    VOCAL_RANGE_FOR_SINGING_EXERCISES.each do |target_note|
      degree = (target_note - root_note) % 12
      FileUtils.mkdir_p("singing/minor")
      progression = MINOR_PROGRESSION.map { |chord| chord.map { |note| note + root_note } }
      file_name = "./singing/minor/#{key}m_#{DEGREES[degree]}.mid"
      info = "Key: #{key} minor Degrees: #{DEGREES[degree]}"
      create_singing_midi_file(tempo, progression, target_note, sleep_duration, info, file_name)
    end
  end
end

main
