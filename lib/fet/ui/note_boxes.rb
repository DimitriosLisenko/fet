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
        note_boxes.each { |note_box| note_box.handle_event_loop(event) }
      end

      def handle_update_loop; end

      private

      def generate_note_boxes
        self.note_boxes = NOTE_BOX_OFFSETS.map do |degree_name, _|
          Fet::Ui::NoteBox.new(note_boxes: self, degree_name: degree_name)
        end
      end
    end
  end
end
