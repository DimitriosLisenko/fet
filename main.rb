require "./midi.rb"

# All 12 degrees
DEGREES = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "b6", "6", "b7", "7"]

# All keys. First element is 5 sharps, 4 sharps, ... 0 sharps/flats, 1 flat, ... all the way up to 6 flats.
# No 6 sharps because the 6 flat versions are enharmonic and more common.
# These keys chosen because they contain only flats and sharps, no double flats/sharps.
MAJOR_KEYS = ["B", "E", "A", "D", "G", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb"]
MINOR_KEYS = ["G#", "C#", "F#", "B", "E", "A", "D", "G", "C", "F", "Bb", "Eb"]

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
MINOR_KEY_ROOT_NOTE = MINOR_KEYS.zip(MAJOR_KEY_ROOT_NOTE.values.map { |i| i - 3 }).to_h


MAJOR_PROGRESSION = [[0, 4, 7], [5, 9, 12], [7, 11, 14], [0, 4, 7]]
MINOR_PROGRESSION = [[0, 3, 7], [5, 8, 12], [7, 10, 14], [0, 3, 7]]

# In midilib, 0 is C(-2).
PIANO_RANGE = (33..120).to_a # A0 - C8 Maybe reduce range a little? Can vary wildly atm
# GUITAR_RANGE = (52..100).to_a # E2 - E6

def main
	number_degrees = ARGV[0].to_i
	if !(1..11).to_a.include?(number_degrees)
		puts "Usage: ruby main.rb {number of degrees} {number of exercises} {tempo}"
		puts "Please enter number of degrees from 1 to 11 inclusive"
		return
	end
	number_exercises = ARGV[1].to_i
	if !(1..200).to_a.include?(number_exercises)
		puts "Usage: ruby main.rb {number of degrees} {number of exercises} {tempo}"
		puts "Please enter number of exercises to create from 1 to 200 inclusive"
		return
	end
	tempo = ARGV[2].to_i
	if !(40..250).to_a.include?(tempo)
		puts "Usage: ruby main.rb {number of degrees} {number of exercises} {tempo}"
		puts "Please enter tempo from 40 to 250 inclusive"
		return
	end

	Dir.mkdir("minor") unless File.exists?("major")
	Dir.mkdir("major") unless File.exists?("major")

	number_exercises.times do
		# Create major key exercises
		root = MAJOR_KEY_ROOT_NOTE.to_a.sample
		select_notes_recursive(PIANO_RANGE, [], root, number_degrees, "major", tempo)

		# Create minor key exercises
		root = MINOR_KEY_ROOT_NOTE.to_a.sample
		select_notes_recursive(PIANO_RANGE, [], root, number_degrees, "minor", tempo)
	end
end

def select_notes_recursive(all_notes, chosen_notes, root, number_degrees, key_type, tempo)
	if number_degrees == 0
		chosen_notes.sort! # So file name corresponds to degree of lowest to highest
		info = "Key: #{root[0]} #{key_type} Degrees: #{chosen_notes.map { |i| DEGREES[(i - root[1]) % 12] }}"
		puts info if ARGV[3] == "debug"

		if key_type == "major"
			progression = MAJOR_PROGRESSION.map { |chord| chord.map { |note| note + root[1] } }
		elsif key_type == "minor"
			progression = MINOR_PROGRESSION.map { |chord| chord.map { |note| note + root[1] } }
		end

		file_name = "./#{key_type}/#{root[0]}#{key_type == "major" ? "M" : "m"}_#{chosen_notes.map { |i| DEGREES[(i - root[1]) % 12] }.join("_")}.mid"

		create_midi_file(tempo, progression, chosen_notes, info, file_name)
		return
	end

	random_note = all_notes.sample
	chosen_notes << random_note

	degree = (random_note - root[1]) % 12
	all_notes_without_note_degree = all_notes.select { |note| (note - root[1]) % 12 != degree }
	select_notes_recursive(all_notes_without_note_degree, chosen_notes, root, number_degrees - 1, key_type, tempo)
end

main

# All 12 notes (ended up not using it, but could use it later to show note)
# "Note Names: #{chosen_notes.map { |i| NOTES[i % 12] }}" # Would need to figure out whether to use flat/natural/sharp for a given key - could have map with this info
# To get notes for starting from a specific root, do something like
# root_index = NOTES.index { |note| note.include?(root_note) }
# x[root_index..-1] + x[0...root_index]
# NOTES = [["B#", "C"], ["C#", "Db"], ["D"], ["D#", "Eb"], ["E", "Fb"], ["E#", "F"], ["F#", "Gb"], ["G"], ["G#", "Ab"], ["A"], ["A#", "Bb"], ["B", "Cb"]]
