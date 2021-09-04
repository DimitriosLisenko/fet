# frozen_string_literal: true

require "ruby2d"
require_relative "color_scheme"

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
        self.text = generate_text
      end

      def handle_event_loop(event); end

      def handle_update_loop; end

      def level_completed_event
        game.level.answered_correctly? ? score.answer_correctly(*game.level.degree_indices) : score.answer_incorrectly(*game.level.degree_indices)
        text.text = text_value
      end

      private

      attr_accessor :score

      TEXT_SIZE = 36
      X_OFFSET = 508
      Y_OFFSET = 90
      private_constant :TEXT_SIZE, :X_OFFSET, :Y_OFFSET

      def text_value
        return "#{score.answered_correctly}/#{score.questions_asked}"
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
    end
  end
end
