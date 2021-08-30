# frozen_string_literal: true

require "midilib/sequence"
require "midilib/consts"

module Fet
  # Interface with the midilib library to generate MIDI files
  class MidilibInterface
    def initialize(tempo:, progression:, notes:, info:, filename:)
      self.tempo = tempo
      self.progression = progression
      self.notes = notes
      self.info = info
      self.filename = filename
      self.sequence = MIDI::Sequence.new
      self.track = create_track_with_progression
    end

    def create_listening_midi_file
      # Temporarily change tempo so notes always sound for the same time
      with_temporary_tempo_change(120) do
        add_rest(2 * quarter_note_length)
        play_notes_as_chord(notes, quarter_note_added)

        # Play the notes sequentially too
        add_rest(6 * quarter_note_length)
        play_notes_sequentially(notes, quarter_note_length)
      end

      write_sequence_to_file
    end

    def create_singing_midi_file(sleep_duration)
      # Play the note after waiting for a specified amount of time
      add_seconds_of_rest(sleep_duration) do
        play_notes_sequentially(notes, quarter_note_length)
      end

      write_sequence_to_file
    end

    private

    attr_accessor :tempo, :progression, :notes, :info, :filename, :sequence, :track

    def write_sequence_to_file
      File.open(filename, "wb") { |file| seq.write(file) }
    end

    def add_seconds_of_rest(seconds)
      # Change tempo to 60 so that sleep_duration quarter notes corresponds to number of seconds
      with_temporary_tempo_change(60) do
        # Sleep for the requested duration
        add_rest(seconds * quarter_note_length)
        yield
      end
    end

    def play_notes_as_chord(the_notes, rest_after_chord)
      the_notes.each do |note|
        track.events << MIDI::NoteOn.new(0, note, 127, 0) # track number, note, volume, time to add
      end

      the_notes.each.with_index do |note, index|
        time_interval = index.zero? ? rest_after_chord : 0
        track.events << MIDI::NoteOff.new(0, note, 127, time_interval)
      end
    end

    def play_notes_sequentially(the_notes, rest_between_notes)
      the_notes.each do |note|
        track.events << MIDI::NoteOn.new(0, note, 127, 0) # track number, note, volume, time to add
        track.events << MIDI::NoteOff.new(0, note, 127, rest_between_notes)
      end
    end

    def add_rest(duration)
      track.events << MIDI::NoteOff.new(0, 0, 0, duration)
    end

    def with_temporary_tempo_change(new_tempo)
      change_tempo(new_tempo)
      yield
      change_tempo(tempo)
    end

    def change_tempo(new_tempo)
      track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(new_tempo))
    end

    def create_track_with_progression
      create_info_track
      track = create_instrument_track

      # Create the progression
      progression.each do |chord|
        play_notes_as_chord(chord, quarter_note_length)
      end

      return track
    end

    def create_info_track
      # Create a first track for the sequence. This holds tempo events and meta info.
      track = MIDI::Track.new(sequence)
      sequence.tracks << track
      track.events << MIDI::Tempo.new(MIDI::Tempo.bpm_to_mpq(tempo))
      track.events << MIDI::MetaEvent.new(MIDI::META_SEQ_NAME, info)
      return track
    end

    def create_instrument_track
      # Create a track to hold the notes. Add it to the sequence.
      track = MIDI::Track.new(sequence)
      sequence.tracks << track
      track.name = info
      track.instrument = MIDI::GM_PATCH_NAMES[0] # This is the piano patch
      track.events << MIDI::ProgramChange.new(0, 1, 0) # Specify instrument as 2nd argument - see consts in midilib
      return track
    end

    def quarter_note_length
      return sequence.note_to_delta("quarter")
    end
  end
end
