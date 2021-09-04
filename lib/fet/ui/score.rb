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

      attr_accessor :score

      TEXT_SIZE = 36
      X_OFFSET = 508
      Y_OFFSET = 90
      private_constant :TEXT_SIZE, :X_OFFSET, :Y_OFFSET

      def text_value
        return "#{score.answered_correctly}/#{game.level.question_number}"
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
        # TODO: this is not quite right because for multiple notes *some* can be correct
        # TODO: also, this is not right because for 2 degrees it increases the score by 2 rather than 1
        game.level.answered_correctly? ? score.answer_correctly(*game.level.degree_indices) : score.answer_incorrectly(*game.level.degree_indices)
      end

      def update_text
        text.text = text_value
      end
    end
  end
end
