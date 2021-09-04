# frozen_string_literal: true

require_relative "color_scheme"
require_relative "note_boxes"

module Fet
  module Ui
    # Handles events for NoteBox
    module NoteBoxLoopHandler
      def handle_event_loop(event)
        handle_click_event(event)
        handle_keyboard_event(event)
      end

      def handle_update_loop; end

      private

      attr_accessor :keyboard_accidental

      def handle_click_event(event)
        return unless event.is_a?(Ruby2D::Window::MouseEvent)
        return unless event.type == :down
        return unless event.button == :left

        handle_selected if square.contains?(event.x, event.y)
      end

      def handle_keyboard_event(event)
        return unless event.is_a?(Ruby2D::Window::KeyEvent)
        return unless event.type == :down

        input = determine_keyboard_input(event)
        handle_selected if degree_instance.degree_index == input_degree_instance(input)&.degree_index
      end

      KEYBOARD_TO_ACCIDENTAL_MAP = {
        "=" => "#",
        "0" => "",
        "-" => "b",
      }.deep_freeze
      private_constant :KEYBOARD_TO_ACCIDENTAL_MAP

      def determine_keyboard_input(event)
        update_keyboard_input_accidental(event)

        return case event.key
               when *(1..7).map(&:to_s)
                 input = "#{keyboard_accidental}#{event.key}"
                 self.keyboard_accidental = ""
                 return input
               else
                 return nil
               end
      end

      def update_keyboard_input_accidental(event)
        case event.key
        when *KEYBOARD_TO_ACCIDENTAL_MAP.keys
          self.keyboard_accidental = KEYBOARD_TO_ACCIDENTAL_MAP[event.key]
        when *(1..7).map(&:to_s)
          # noop
        else
          self.keyboard_accidental = ""
        end
      end

      def handle_keyboard_input_degree(event)
        case event.key
        when *(1..7).map(&:to_s)
          input = "#{keyboard_accidental}#{event.key}"
          self.keyboard_accidental = ""
          return input
        end
      end

      def input_degree_instance(input)
        return nil if input.nil?

        return Fet::Degree.new(input)
      rescue Fet::InvalidDegreeName
        # TODO: alterenatively, make degrees like b1 or #1 valid degree names, though that would need a bit of a refactor
        return nil
      end

      def handle_selected
        self.keyboard_accidental = ""

        if level_over?
          note_music.play
        else
          self.selected = true
          update_colors
          note_boxes.level.game.level_completed_event if correct?
        end
      end

      def update_colors
        square.color = color
        text.color = text_color
      end
    end
  end
end