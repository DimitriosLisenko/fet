# frozen_string_literal: true

require "test_helper"

module Fet
  module Ui
    class CustomEventTest < Minitest::Test
      def test_valid_custom_event_creation
        CustomEvent::EVENT_TYPES.each do |event_type|
          CustomEvent.new(event_type)
        end
      end

      def test_invalid_custom_event_creation
        assert_raises(InvalidCustomEventType) { CustomEvent.new(:hello_world) }
      end
    end
  end
end
