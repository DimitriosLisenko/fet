# frozen_string_literal: true

module Fet
  module Ui
    # Holds state for the current level of the game
    class Level
      def initialize(game)
        self.game = game
      end

      def handle_event_loop(event); end

      def handle_update_loop; end

      private

      attr_accessor :game, :accidental
    end
  end
end
