#!/usr/bin/env ruby

require "fileutils"
require "./lib/fet.rb"
require "./midi.rb"

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
MINOR_KEY_ROOT_NOTE = Fet::MusicTheory::MINOR_KEYS.zip(MAJOR_KEY_ROOT_NOTE.values.map { |i| i - 3 }).to_h

# MAJOR_PROGRESSION = [[0, 4, 7], [5, 9, 12], [7, 11, 14], [0, 4, 7]]
# MINOR_PROGRESSION = [[0, 3, 7], [5, 8, 12], [7, 10, 14], [0, 3, 7]]
MAJOR_PROGRESSION = [[0, 4, 7], [0, 5, 9], [-1, 5, 7], [0, 4, 7]]
MINOR_PROGRESSION = [[0, 3, 7], [0, 5, 8], [-1, 5, 7], [0, 3, 7]]

# PIANO_RANGE = (Fet::MidiMusicTheory.note_midi_value("A", 0)..Fet::MidiMusicTheory.note_midi_value("C", 8)).to_a
PIANO_RANGE = (Fet::MidiMusicTheory.note_midi_value("A", 1)..Fet::MidiMusicTheory.note_midi_value("C", 7)).to_a
# GUITAR_RANGE = (Fet::MidiMusicTheory.note_midi_value("E", 2)..Fet::MidiMusicTheory.note_midi_value("E", 6)).to_a

def main
  number_degrees = ARGV[0].to_i
  if !(1..11).to_a.include?(number_degrees)
    puts "Usage: ruby generate_listening_exercises.rb {number of degrees} {number of exercises} {tempo}"
    puts "Please enter number of degrees from 1 to 11 inclusive"
    return
  end
  number_exercises = ARGV[1].to_i
  if !(1..1000).to_a.include?(number_exercises)
    puts "Usage: ruby generate_listening_exercises.rb {number of degrees} {number of exercises} {tempo}"
    puts "Please enter number of exercises to create from 1 to 200 inclusive"
    return
  end
  tempo = ARGV[2].to_i
  if !(40..250).to_a.include?(tempo)
    puts "Usage: ruby generate_listening_exercises.rb {number of degrees} {number of exercises} {tempo}"
    puts "Please enter tempo from 40 to 250 inclusive"
    return
  end

  FileUtils.mkdir_p("listening/minor")
  FileUtils.mkdir_p("listening/major")

  number_exercises.times do
    # Create major key exercises
    root = MAJOR_KEY_ROOT_NOTE.to_a.sample
    until select_notes_recursive(PIANO_RANGE, [], root, number_degrees, "major", tempo); end

    # Create minor key exercises
    root = MINOR_KEY_ROOT_NOTE.to_a.sample
    until select_notes_recursive(PIANO_RANGE, [], root, number_degrees, "minor", tempo); end
  end
end

def select_notes_recursive(all_notes, chosen_notes, root, number_degrees, key_type, tempo)
  if number_degrees == 0
    chosen_notes.sort! # So file name corresponds to degree of lowest to highest
    info = "Key: #{root[0]} #{key_type} Degrees: #{chosen_notes.map { |i| Fet::MusicTheory::DEGREES[(i - root[1]) % 12] }} Notes: #{chosen_notes}"
    puts info if ARGV[3] == "debug"

    if key_type == "major"
      progression = MAJOR_PROGRESSION.map { |chord| chord.map { |note| note + root[1] } }
    elsif key_type == "minor"
      progression = MINOR_PROGRESSION.map { |chord| chord.map { |note| note + root[1] } }
    end

    file_name = "./listening/#{key_type}/#{root[0]}#{key_type == "major" ? "M" : "m"}_#{chosen_notes.map { |i| "#{Fet::MusicTheory::DEGREES[degree(root[1], i)]}(#{midi_note_name(root[0], degree(root[1], i), i)})" }.join("_")}.mid"
    return false if File.exists?(file_name)

    create_midi_file(tempo, progression, chosen_notes, info, file_name)
    return true
  end

  random_note = all_notes.sample
  chosen_notes << random_note

  degree = (random_note - root[1]) % 12
  all_notes_without_note_degree = all_notes.select { |note| (note - root[1]) % 12 != degree }
  select_notes_recursive(all_notes_without_note_degree, chosen_notes, root, number_degrees - 1, key_type, tempo)
end

def degree(root_midi_value, note_midi_value)
  return (note_midi_value - root_midi_value) % 12
end

def midi_note_name(root_name, note_degree_index, note_midi_value)
  return degree_name(root_name, note_degree_index) + octave_value(note_midi_value).to_s
end

def degree_name(root_name, degree_index)
  notes_array = Fet::MusicTheory.notes_of_mode(root_name, "major")

  note_degree_name = Fet::MusicTheory::DEGREES[degree_index]
  is_flattened_degree = note_degree_name[0] == "b"
  note_degree = is_flattened_degree ? note_degree_name[1].to_i : note_degree_name[0].to_i

  result = notes_array[note_degree - 1]
  return is_flattened_degree ? Fet::Note.new(result).flattened_note.full_note : result
end

def octave_value(midi_value)
  return (midi_value - 12) / 12
end

main

# All 12 notes (ended up not using it, but could use it later to show note)
# "Note Names: #{chosen_notes.map { |i| NOTES[i % 12] }}" # Would need to figure out whether to use flat/natural/sharp for a given key - could have map with this info
# To get notes for starting from a specific root, do something like
# root_index = NOTES.index { |note| note.include?(root_note) }
# x[root_index..-1] + x[0...root_index]
# NOTES = [["B#", "C"], ["C#", "Db"], ["D"], ["D#", "Eb"], ["E", "Fb"], ["E#", "F"], ["F#", "Gb"], ["G"], ["G#", "Ab"], ["A"], ["A#", "Bb"], ["B", "Cb"]]
