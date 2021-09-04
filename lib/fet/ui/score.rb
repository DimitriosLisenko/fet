# frozen_string_literal: true

require "ruby2d"
require_relative "color_scheme"
require_relative "custom_event"

module Fet
  module Ui
    # Shows the UI elements for score
    class Score
      attr_accessor :game, :text

      def initialize(game)
        self.game = game
        self.score = Fet::Score.new
        self.correct_questions = 0
      end

      def start
        self.text ||= generate_text
        update_text
      end

      def handle_event_loop(event)
        handle_level_started_event(event)
        handle_level_complete_event(event)
      end

      def handle_update_loop; end

      private

      attr_accessor :score, :correct_questions

      TEXT_SIZE = 36
      X_OFFSET = 508
      Y_OFFSET = 90
      private_constant :TEXT_SIZE, :X_OFFSET, :Y_OFFSET

      def text_value
        return "#{correct_questions}/#{game.level.question_number}"
      end

      def generate_text
        return Ruby2D::Text.new(
          text_value,
          x: X_OFFSET, y: Y_OFFSET,
          font: "assets/fonts/PTSans/PTSans-Regular.ttf",
          size: TEXT_SIZE,
          color: ColorScheme::WHITE,
        )
      end

      def handle_level_started_event(event)
        return unless event.is_a?(CustomEvent) && event.type == CustomEvent::EVENT_TYPE_LEVEL_STARTED

        update_text
      end

      def handle_level_complete_event(event)
        return unless event.is_a?(CustomEvent) && event.type == CustomEvent::EVENT_TYPE_LEVEL_COMPLETE

        update_score
        update_text
      end

      def update_score
        note_boxes = game.level.note_boxes
        correct_note_boxes = note_boxes.correct_note_boxes

        user_selected_correct_note_boxes = correct_note_boxes.select(&:user_selected)
        non_user_selected_correct_note_boxes = correct_note_boxes.reject(&:user_selected)

        score.answer_correctly(*user_selected_correct_note_boxes.map(&:degree_index))
        score.answer_incorrectly(*non_user_selected_correct_note_boxes.map(&:degree_index))

        self.correct_questions += 1 if non_user_selected_correct_note_boxes.empty?
      end

      def update_text
        text.text = text_value
      end
    end
  end
end
