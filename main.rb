# All 12 notes
NOTES = [["B#", "C"], ["C#", "Db"], ["D"], ["D#", "Eb"], ["E", "Fb"], ["E#", "F"], ["F#", "Gb"], ["G"], ["G#", "Ab"], ["A"], ["A#", "Bb"], ["B", "Cb"]]

# All 12 degrees
DEGREES = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "b6", "6", "b7", "7"]

# All keys. First element is 5 sharps, 4 sharps, ... 0 sharps/flats, 1 flat, ... all the way up to 6 flats.
# No 6 sharps because the 6 flat versions are enharmonic and more common.
# These keys chosen because they contain only flats and sharps, no double flats/sharps.
MAJOR_KEYS = ["B", "E", "A", "D", "G", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb"]
MINOR_KEYS = ["G#", "C#", "F#", "B", "E", "A", "D", "G", "C", "F", "Bb", "Eb"] # Need for file name, but not for calculation

MAJOR_KEY_ROOT_NOTE = {
	"B": 47,
	"E": 40,
	"A": 45,
	"D": 50,
	"G": 43,
	"C": 48,
	"F": 41,
	"Bb": 46,
	"Eb": 51,
	"Ab": 44,
	"Db": 49,
	"Gb": 42
}

# Piano has notes A0 to C8

# Input: 1 <= n <= 11 (number of DISTINCT DEGREES to play), 60 <= t <= 300 (tempo)
# Create 12 major key progressions and 12 minor key progressions at tempo t
# Create for all 88 piano keys combinations of n DISTINCT DEGREES (a shit fuck ton!)
# This means if degree 2 was chosen for first note, all 2's (7 or so out of 88) cannot be use for next notes.
# For each of the 24 keys, add all the note combos and name them correctly (e.g. C_Major_2_b3.mid), which is an even more shit fuck ton.

# To get notes for a specific key, do something like
# (NOTES.index { |note| root.include?(note) }).times { |i| NOTES << NOTES.shift }
# Better yet as it's non-destructive:
# root_index = NOTES.index { |note| root.include?(note) }
# x[root_index..-1] + x[0...root_index]

# Class Output something along the lines of (depends on MIDI library)
# class Output
# 	@key: XMajor/Xminor
#	@degrees: [...] (sort by last character, which will be the number)
#	@tempo: whatever
# }

# Given same offset, will play relative major and minor
MAJOR_PROGRESSION = [[0, 4, 7], [5, 9, 12], [7, 11, 14], [0, 4, 7]]
MINOR_PROGRESSION = [[-3, 0, 4], [2, 5, 9], [4, 7, 11], [3, 0, 4]]

# In midilib, 0 is C(-2).
PIANO_RANGE = (33..120).to_a # A0 - C8
GUITAR_RANGE = (52..100).to_a # E2 - E6

# The sequence is quarter note each of those chords, quarter note rest, quarter/half note the note to guess

# If root of progression is x, then (note - x) % 12 is the interval!
# e.g. (33..120).to_a.select { |i| (i - 64) % 12 != 0 }

# MAJOR_KEYS will be a map now
# For each value in maj keys
# 	play MAJOR_PROGRESSION and quarter note rest
# 	play interval
# 	save as XM_b2_5.mid for example
#

def main
	number_notes = ARGV[0].to_i
	if !(1..11).to_a.include?(number_notes)
		puts "Please enter number of degrees from 1 to 11 inclusive"
		return
	end
	# tempo = gets.chomp.to_i

	# MAJOR_KEY_ROOT_NOTE.each do |root_name, root_value|
		# select_notes_recursive(PIANO_RANGE, [], root_value, number_notes)
		select_notes_recursive(PIANO_RANGE, [], 1, number_notes)
	# end
end

def select_notes_recursive(all_notes, chosen_notes, root, number_notes)
	# if n == 0, do stuff (MIDI, file) and return. Do I need to save into array what notes chosen? Probs
	if number_notes == 0
		p "CHOSEN NOTES: #{chosen_notes.map { |i| DEGREES[(i - root) % 12] }}"
		return
	end
	all_notes.each do |chosen_note|
		next if chosen_notes.size > 0 && chosen_note < chosen_notes[-1]
		chosen_notes << chosen_note
		degree = (chosen_note - root) % 12
		all_notes_without_note_degree = all_notes.select { |note| (note - root) % 12 != degree }
		select_notes_recursive(all_notes_without_note_degree, chosen_notes, root, number_notes - 1)
		chosen_notes.pop
	end
end

main
