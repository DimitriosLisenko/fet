# frozen_string_literal: true

module Fet
  module Ui
    # Class that handles draw all degree boxes
    class NoteBoxes
      attr_accessor :level, :note_boxes

      GLOBAL_X_OFFSET = 60
      GLOBAL_Y_OFFSET = 244
      NOTE_BOX_OFFSETS = {
        "1" => [(GLOBAL_X_OFFSET + 0), GLOBAL_Y_OFFSET + 75],
        "2" => [(GLOBAL_X_OFFSET + 75), GLOBAL_Y_OFFSET + 75],
        "3" => [(GLOBAL_X_OFFSET + 150), GLOBAL_Y_OFFSET + 75],
        "4" => [(GLOBAL_X_OFFSET + 225), GLOBAL_Y_OFFSET + 75],
        "5" => [(GLOBAL_X_OFFSET + 300), GLOBAL_Y_OFFSET + 75],
        "6" => [(GLOBAL_X_OFFSET + 375), GLOBAL_Y_OFFSET + 75],
        "7" => [(GLOBAL_X_OFFSET + 450), GLOBAL_Y_OFFSET + 75],
        "b2" => [(GLOBAL_X_OFFSET + 40), GLOBAL_Y_OFFSET],
        "b3" => [(GLOBAL_X_OFFSET + 115), GLOBAL_Y_OFFSET],
        "b5" => [(GLOBAL_X_OFFSET + 265), GLOBAL_Y_OFFSET],
        "b6" => [(GLOBAL_X_OFFSET + 340), GLOBAL_Y_OFFSET],
        "b7" => [(GLOBAL_X_OFFSET + 415), GLOBAL_Y_OFFSET],
      }.deep_freeze

      def initialize(level)
        self.level = level
      end

      def start
        self.note_boxes ||= generate_note_boxes
        note_boxes.each(&:start)
      end

      def handle_event_loop(event)
        handle_note_selected_event(event)
        note_boxes.each { |note_box| note_box.handle_event_loop(event) }
      end

      def handle_update_loop
        @nil_put = false if @nil_put.nil?
        @sung_times ||= 0
        # latest_frequency = nil
        # loop do
        #   puts latest_frequency
        # rescue ThreadError
        #   break
        # end
        latest_frequency = level.game.recorder.read_frequency

        note_boxes.each { |note_box| note_box.sung = false }

        # NOTE: there are filters in place that ensure the frequency we get here is a valid MIDI note
        if latest_frequency.nil?
          @sung_times = [0, @sung_times - 1].max
          puts unless @nil_put
          @nil_put = true
        else
          midi_value, cents = Fet::Frequency.frequency_to_midi_value(latest_frequency)
          sung_degree_index = level.degrees.degree_index_of_midi_value(midi_value)
          sung_degree_name = Fet::Degree.from_degree_index(sung_degree_index, accidental_type: "b").degree_name
          puts "#{sung_degree_name}\t#{latest_frequency}\t#{midi_value}#{"+" if cents.positive? || cents.zero?}#{cents}"
          # if cents.abs <= 30 # can do this to require more strict singing
          @nil_put = false
          sung_note_box = note_boxes.detect { |note_box| note_box.degree_name == sung_degree_name }
          sung_note_box.sung = true
          if @sung_degree == sung_degree_name
            @sung_times = [10, @sung_times + 1].min
            if @sung_times == 10 && !all_correct_selected?
              sung_note_box.select_by_singing
            end
          else
            @sung_times = 1
            @sung_degree = sung_degree_name
          end
        end

        note_boxes.each { |note_box| note_box.send(:update_colors) }
      end

      def all_correct_selected?
        return (correct_note_boxes.map(&:degree_name) & selected_note_boxes.map(&:degree_name)).size == correct_note_boxes.size
      end

      def any_wrong_selected?
        return selected_note_boxes.any? { |note_box| !note_box.correct? }
      end

      def correct_remaining
        return note_boxes.select { |note_box| !note_box.selected && note_box.correct? }
      end

      def correct_note_boxes
        return note_boxes.select(&:correct?)
      end

      def selected_note_boxes
        return note_boxes.select(&:selected)
      end

      private

      def generate_note_boxes
        NOTE_BOX_OFFSETS.map do |degree_name, _|
          Fet::Ui::NoteBox.new(note_boxes: self, degree_name: degree_name)
        end
      end

      def handle_note_selected_event(event)
        return unless event.is_a?(CustomEvent) && event.type == CustomEvent::EVENT_TYPE_NOTE_SELECTED

        if all_correct_selected?
          level.game.set_level_complete_event_flag
        elsif any_wrong_selected?
          correct_remaining.first.manually_select
        end
      end
    end
  end
end
