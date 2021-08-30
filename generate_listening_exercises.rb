#!/usr/bin/env ruby

require "fileutils"
require "./lib/fet.rb"
require "./midi.rb"

# The reason number of exercises is required is because the actual number generated is quite large...
# it's more like 88C3, but a bit smaller because one you choose 1, you actually exclude some of the 88 other than just itself
# (i.e. if you chose the 3rd degree, you exclude the rest of the 3rd degrees too)
# 2 degrees => 21592 (left it for a while and it seemed to stop at this value) - comparable to 64C2 * 12 = 24192
# 3 degrees => 252398 (before I stopped it, there was more being generated)

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

  number_exercises.times do
    # Create major key exercises
    root = Fet::MAJOR_ROOT_MIDI_VALUES.to_a.sample
    until select_notes_recursive(Fet::REDUCED_BY_OCTAVE_PIANO_RANGE, [], root, number_degrees, "major", tempo); end

    # Create minor key exercises
    root = Fet::MINOR_ROOT_MIDI_VALUES.to_a.sample
    until select_notes_recursive(Fet::REDUCED_BY_OCTAVE_PIANO_RANGE, [], root, number_degrees, "minor", tempo); end
  end
end

def select_notes_recursive(all_notes, chosen_notes, root, number_degrees, key_type, tempo)
  if number_degrees == 0
    chosen_notes.sort! # So file name corresponds to degree of lowest to highest
    info = "Key: #{root[0]} #{key_type} Degrees: #{chosen_notes.map { |i| Fet::MusicTheory::DEGREES[(i - root[1]) % 12] }} Notes: #{chosen_notes}"
    puts info if ARGV[3] == "debug"

    progression = Fet::ChordProgression.new(offset: root[1], template_type: key_type).with_offset

    file_name = "./listening/#{key_type}/#{root[0]}#{key_type == "major" ? "M" : "m"}_#{chosen_notes.map { |i| note_filename_part(root[0], i) }.join("_")}.mid"
    return false if File.exists?(file_name)

    Fet::MidilibInterface.new(tempo: tempo, progression: progression, notes: chosen_notes, info: info, filename: file_name).create_listening_midi_file
    return true
  end

  selected_note = all_notes.sample
  chosen_notes << selected_note

  all_notes_without_note_degree = all_notes.select { |note| Fet::MidiNote.new(note).degree(root[1]) != Fet::MidiNote.new(selected_note).degree(root[1]) }
  select_notes_recursive(all_notes_without_note_degree, chosen_notes, root, number_degrees - 1, key_type, tempo)
end

def note_filename_part(root_name, note_midi_value)
  octave_value = Fet::MidiNote.new(note_midi_value).octave_number
  degrees_instance = Fet::Degrees.new(root_name: root_name, octave_value: octave_value)
  degree_name = degrees_instance.degree_names_of_midi_value(note_midi_value).last
  note_name = degrees_instance.note_name_of_degree(degree_name)
  return "#{degree_name}(#{note_name}#{octave_value})"
end

main

# All 12 notes (ended up not using it, but could use it later to show note)
# "Note Names: #{chosen_notes.map { |i| NOTES[i % 12] }}" # Would need to figure out whether to use flat/natural/sharp for a given key - could have map with this info
# To get notes for starting from a specific root, do something like
# root_index = NOTES.index { |note| note.include?(root_note) }
# x[root_index..-1] + x[0...root_index]
# NOTES = [["B#", "C"], ["C#", "Db"], ["D"], ["D#", "Eb"], ["E", "Fb"], ["E#", "F"], ["F#", "Gb"], ["G"], ["G#", "Ab"], ["A"], ["A#", "Bb"], ["B", "Cb"]]
