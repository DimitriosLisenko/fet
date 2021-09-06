# frozen_string_literal: true

module Fet
  # Use MidilibInterface to create concrete MIDI files
  module MidiFileGenerator
    def create_full_question
      set_progression_on_track
      add_rest(2 * quarter_note_length)
      play_notes_as_chord(notes, quarter_note_length)
      add_rest(3 * quarter_note_length)
      write_sequence_to_file
    end

    def create_chord_progression_of_question
      set_progression_on_track
      add_rest(1 * quarter_note_length)
      write_sequence_to_file
    end

    def create_notes_only
      play_notes_as_chord(notes, quarter_note_length)
      add_rest(1 * quarter_note_length)
      write_sequence_to_file
    end

    def create_listening_midi_file
      set_progression_on_track

      add_rest(2 * quarter_note_length)
      play_notes_as_chord(notes, quarter_note_length)

      add_rest(6 * quarter_note_length)
      play_notes_sequentially(notes, quarter_note_length)

      write_sequence_to_file
    end

    def create_singing_midi_file(sleep_duration)
      set_progression_on_track

      add_seconds_of_rest(sleep_duration)
      play_notes_sequentially(notes, quarter_note_length)
      add_rest(3 * quarter_note_length)

      write_sequence_to_file
    end
  end
end
