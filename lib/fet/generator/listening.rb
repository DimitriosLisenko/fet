# frozen_string_literal: true

module Fet
  module Generator
    # Class that generates MIDI files for the listening exercises
    class Listening
      # The reason number of exercises is required is because the actual number generated is quite large
      # For three degrees, it's something like 88C3, but a bit smaller because one you choose 1, you actually exclude some of the 88 other than just itself
      # (i.e. if you chose the b2 degree, you exclude the rest of the b2 degrees too)
      # 2 degrees => 21592 (left it for a while and it seemed to stop at this value) - comparable to 64C2 * 12 = 24192
      # 3 degrees => 252398 (before I stopped it, there was more being generated)
      def initialize(exercises:, tempo:, degrees:, all_single_degree:, directory_prefix: "")
        self.number_of_exercises = exercises
        self.all_single_degree = all_single_degree
        self.tempo = tempo
        self.number_of_degrees = degrees
        self.note_range = Fet::REDUCED_BY_OCTAVE_PIANO_RANGE
        self.directory_prefix = directory_prefix
      end

      def generate
        all_single_degree ? generate_all_single_degree_exercises : generate_number_of_exercises
      end

      private

      attr_accessor :number_of_exercises, :tempo, :number_of_degrees, :note_range, :all_single_degree, :directory_prefix

      def generate_all_single_degree_exercises
        Fet::MAJOR_ROOT_MIDI_VALUES.each do |root|
          note_range.each do |note|
            select_notes_recursive([note], [], root, 1, "major")
          end
        end

        Fet::MINOR_ROOT_MIDI_VALUES.each do |root|
          note_range.each do |note|
            select_notes_recursive([note], [], root, 1, "minor")
          end
        end
      end

      def generate_number_of_exercises
        number_of_exercises.times do
          # Create major key exercises
          root = Fet::MAJOR_ROOT_MIDI_VALUES.to_a.sample
          until select_notes_recursive(note_range, [], root, number_of_degrees, "major"); end

          # Create minor key exercises
          root = Fet::MINOR_ROOT_MIDI_VALUES.to_a.sample
          until select_notes_recursive(note_range, [], root, number_of_degrees, "minor"); end
        end
      end

      def select_notes_recursive(all_notes, chosen_notes, root, number_degrees, key_type)
        return create_midi_file(chosen_notes, root, key_type) if number_degrees.zero?

        selected_note = all_notes.sample
        chosen_notes << selected_note

        all_notes_without_note_degree = all_notes.reject { |note| Fet::MidiNote.new(note).degree(root[1]) == Fet::MidiNote.new(selected_note).degree(root[1]) }
        select_notes_recursive(all_notes_without_note_degree, chosen_notes, root, number_degrees - 1, key_type)
      end

      def create_midi_file(chosen_notes, root, key_type)
        # Sort so that the file name corresponds to degree of lowest to highest
        chosen_notes = chosen_notes.sort

        filename = full_filename(key_type, root, chosen_notes)
        return false if File.exist?(filename)

        progression = Fet::ChordProgression.new(offset: root[1], template_type: key_type).with_offset
        Fet::MidilibInterface.new(
          tempo: tempo, progression: progression, notes: chosen_notes, info: generate_midi_info(key_type, root, chosen_notes), filename: filename,
        ).create_listening_midi_file
        return true
      end

      def generate_midi_info(key_type, root, chosen_notes)
        return [
          "Key: [#{root[0]} #{key_type}]",
          "Degrees: [#{chosen_notes.map { |i| Fet::MusicTheory::DEGREES[(i - root[1]) % 12] }}]",
          "Notes: [#{chosen_notes}]",
        ].join(" ")
      end

      def full_filename(key_type, root, chosen_notes)
        result = File.join(*[directory_prefix, "listening", key_type].reject(&:empty?))
        filename = root[0].to_s # note, e.g. Db
        filename += key_type == "major" ? "M" : "m" # type of note, M or m
        filename += "_" # delimiter
        filename += chosen_notes.map { |i| note_filename_part(root[0], root[1], i) }.join("_") # chosen notes description, e.g. b7(Cb4)
        filename += ".mid" # extension
        return File.join(result, filename)
      end

      def note_filename_part(root_name, root_midi_value, note_midi_value)
        root_octave_value = Fet::MidiNote.new(root_midi_value).octave_number
        degrees_instance = Fet::Degrees.new(root_name: root_name, octave_value: root_octave_value)
        degree_name = degrees_instance.degree_names_of_midi_value(note_midi_value).last
        note_name = degrees_instance.note_name_of_degree(degree_name)
        note_octave_value = Fet::MidiNote.new(note_midi_value).octave_number
        return "#{degree_name}(#{note_name}#{note_octave_value})" # e.g. b7(Cb4)
      end
    end
  end
end
