# Start looking for MIDI module classes in the directory above this one.
# This forces us to use the local copy, even if there is a previously
# installed version out there somewhere.
$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')

require 'midilib/sequence'
require 'midilib/consts'
include MIDI

def create_midi_file(tempo, progression, notes, info, file_name)
  seq = Sequence.new()

  # Create a first track for the sequence. This holds tempo events and meta info.
  track = Track.new(seq)
  seq.tracks << track
  track.events << Tempo.new(Tempo.bpm_to_mpq(tempo))
  track.events << MetaEvent.new(META_SEQ_NAME, info)

  # Create a track to hold the notes. Add it to the sequence.
  track = Track.new(seq)
  seq.tracks << track
  track.name = info
  track.instrument = GM_PATCH_NAMES[0] # This is the piano patch

  # Create the progression
  track.events << ProgramChange.new(0, 1, 0) # Specify instrument as 2nd argument - see consts in midilib
  quarter_note_length = seq.note_to_delta('quarter')
  progression.each do |chord|
    chord.each do |note|
      track.events << NoteOn.new(0, note, 127, 0) # track number, note, volume, time to add
    end
    quarter_note_added = false
    chord.each do |note|
      time_interval = 0
      if !quarter_note_added
        quarter_note_added = true
        time_interval = quarter_note_length
      end
      track.events << NoteOff.new(0, note, 127, time_interval)
    end
  end
  track.events << Tempo.new(Tempo.bpm_to_mpq(120)) # Change tempo so notes always sound for the same time
  track.events << NoteOff.new(0, 0, 0, 2 * quarter_note_length) # Add quarter note rest
  notes.each do |note|
    track.events << NoteOn.new(0, note, 127, 0)
  end
  quarter_note_added = false
  notes.each do |note|
    time_interval = 0
    if !quarter_note_added
      quarter_note_added = true
      time_interval = quarter_note_length
    end
    track.events << NoteOff.new(0, note, 127, time_interval)
  end

  # Play the notes sequentially too
  track.events << NoteOff.new(0, 0, 0, 6 * quarter_note_length)
  notes.each do |note|
    track.events << NoteOn.new(0, note, 127, 0)
    track.events << NoteOff.new(0, note, 127, quarter_note_length)
  end

  File.open(file_name, 'wb') { |file| seq.write(file) } # write to file
end