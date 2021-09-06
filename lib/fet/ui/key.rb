# frozen_string_literal: true

module Fet
  module Ui
    # Shows the current level's key in the UI
    class Key
      attr_accessor :level

      def initialize(level)
        self.level = level
      end

      def start
        self.text ||= generate_text
        text.text = text_value
      end

      private

      attr_accessor :text

      TEXT_SIZE = 36
      X_OFFSET = 60
      Y_OFFSET = 90
      private_constant :TEXT_SIZE, :X_OFFSET, :Y_OFFSET

      def generate_text
        return Ruby2D::Text.new(
          text_value,
          x: X_OFFSET, y: Y_OFFSET,
          font: File.join(Fet.root, "assets/fonts/PTSans/PTSans-Regular.ttf"),
          size: TEXT_SIZE,
          color: ColorScheme::WHITE,
        )
      end

      def text_value
        key_name = level.degrees.root_name
        key_type = level.game.key_type == "major" ? "Major" : "Minor"
        return "#{key_name} #{key_type}"
      end
    end
  end
end
