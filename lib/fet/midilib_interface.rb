# frozen_string_literal: true

require "midilib/sequence"
require "midilib/consts"

module Fet
  # Interface with the midilib library to generate MIDI files
  class MidilibInterface
    include MidiFileGenerator

    def initialize(tempo:, progression:, notes:, info:, filename:)
      self.tempo = tempo
      self.progression = progression
      self.notes = notes
      self.info = info
      self.filename = filename
      self.sequence = MIDI::Sequence.new
      self.track = generate_instrument_track
    end

    private

    attr_accessor :tempo, :progression, :notes, :info, :filename, :sequence, :track

    def write_sequence_to_file
      directory_name = File.dirname(filename)
      FileUtils.mkdir_p(directory_name)
      File.open(filename, "wb") { |file| sequence.write(file) }
    end

    def add_seconds_of_rest(seconds)
      # Change tempo to 60 so that sleep_duration quarter notes corresponds to number of seconds
      with_temporary_tempo_change(60) do
        # Sleep for the requested duration
        add_rest(seconds * quarter_note_length)
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

    def generate_instrument_track
      create_info_track
      return create_instrument_track
    end

    def set_progression_on_track
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
      # NOTE: magic constant will freeze strings, but apparently midilib needs "quarter" to NOT be frozen,
      # so calling dup on it will generate a non-frozen version
      return sequence.note_to_delta("quarter".dup)
    end
  end
end
