# frozen_string_literal: true

require "test_helper"
require "securerandom"

module Fet
  module Generator
    class SingleNoteListeningTest < Minitest::Test
      def setup
        @directory_prefix = File.join("tmp", SecureRandom.uuid)
      end

      def teardown
        FileUtils.rm_rf(@directory_prefix)
      end

      def test_generate_single_note_listening_exercises
        Fet::Generator::SingleNoteListening.new(tempo: 120, directory_prefix: @directory_prefix).generate
        assert_number_of_exercises(expected_number_of_exercises)
      end

      private

      def expected_number_of_exercises
        return Fet::MusicTheory::MAJOR_KEYS.size
      end

      def assert_number_of_exercises(expected_exercise_count)
        ["major", "minor"].each do |key_type|
          exercise_count = Dir[File.join(@directory_prefix, "listening_single_note", key_type, "**", "*")].count { |file| File.file?(file) }
          assert_equal(expected_exercise_count, exercise_count)
        end
      end
    end
  end
end
