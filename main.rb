# All 12 notes
NOTES = [["B#", "C"], ["C#", "Db"], ["D"], ["D#", "Eb"], ["E", "Fb"], ["E#", "F"], ["F#", "Gb"], ["G"], ["G#", "Ab"], ["A"], ["A#", "Bb"], ["B", "Cb"]]

# All 12 degrees
DEGREES = ["1", "b2", "2", "b3", "3", "4", "b5", "5", "b6", "6", "b7", "7"]

# All keys. First element is 5 sharps, 4 sharps, ... 0 sharps/flats, 1 flat, ... all the way up to 6 flats.
# No 6 sharps because the 6 flat versions are enharmonic and more common.
# These keys chosen because they contain only flats and sharps, no double flats/sharps.
MAJOR_KEYS = ["B", "E", "A", "D", "G", "C", "F", "Bb", "Eb", "Ab", "Db", "Gb"]
MINOR_KEYS = ["G#", "C#", "F#", "B", "E", "A", "D", "G", "C", "F", "Bb", "Eb"]

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

