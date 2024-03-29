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

      def handle_update_loop; end

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
