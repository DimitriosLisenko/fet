# frozen_string_literal: true

module Fet
  module Ui
    class NoteBoxTest < Minitest::Test
      # NOTE: I really don't feel this test is strictly required, but need it for 100% branch coverage
      def test_text_color_for_unknown_color
        note_box = NoteBox.new(note_boxes: nil, degree_name: nil)
        NoteBox.stub_any_instance(:color, "hello_world") do
          assert_raises(ImplementationError) { note_box.send(:text_color) }
        end
      end
    end
  end
end
