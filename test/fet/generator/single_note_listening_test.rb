# frozen_string_literal: true

require "test_helper"
require "securerandom"

module Fet
  module Generator
    class SingleNoteListeningTest < Minitest::Test
      def setup
        @directory_prefix = Dir.mktmpdir
      end

      def teardown
        FileUtils.rm_rf(@directory_prefix)
      end

      def test_generate_single_note_listening_exercises
        stub_directory_prefix do
          Fet::Generator::SingleNoteListening.new(tempo: 120).generate
        end
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

      def stub_directory_prefix
        Fet::Generator::SingleNoteListening.stub(:directory_prefix, @directory_prefix) { yield }
      end
    end
  end
end
