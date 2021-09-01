# frozen_string_literal: true

require "test_helper"
require "securerandom"
require "pry-byebug"

module Fet
  module Generator
    class ListeningTest < Minitest::Test
      def setup
        @directory_prefix = File.join("tmp", SecureRandom.uuid)
      end

      def teardown
        FileUtils.rm_rf(@directory_prefix)
      end

      def test_generate_50_exercises
        Fet::Generator::Listening.new(
          exercises: 50, degrees: 1, tempo: 120,
          all_single_degree: false, directory_prefix: @directory_prefix,
        ).generate
        assert_number_of_exercises(50)
      end

      def test_generate_1_exercise_with_guaranteed_collision
        # NOTE: this is required because the search space of files is potentially huge,
        # so they are generated randomly, and skipped if they already exist via File.exist?
        File.stub(:exist?, file_stub) do
          Fet::Generator::Listening.new(
            exercises: 1, degrees: 2, tempo: 200,
            all_single_degree: false, directory_prefix: @directory_prefix,
          ).generate
          assert_number_of_exercises(1)
        end
      end

      def test_generate_all_single_degree_exercises
        Fet::Generator::Listening.new(
          exercises: 200, degrees: 2, tempo: 120,
          all_single_degree: true, directory_prefix: @directory_prefix,
        ).generate
        assert_number_of_exercises(max_number_of_single_degree_exercises)
      end

      private

      def max_number_of_single_degree_exercises
        return Fet::MusicTheory::MAJOR_KEYS.size * Fet::REDUCED_BY_OCTAVE_PIANO_RANGE.size
      end

      def assert_number_of_exercises(expected_exercise_count)
        ["major", "minor"].each do |key_type|
          exercise_count = Dir[File.join(@directory_prefix, "listening", key_type, "**", "*")].count { |file| File.file?(file) }
          assert_equal(expected_exercise_count, exercise_count)
        end
      end

      def file_stub
        hash = {}
        lambda do |filename|
          ["major", "minor"].each do |key_type|
            next unless filename.include?(key_type)
            return false if hash.include?(key_type)

            hash[key_type] = true
            return true
          end
        end
      end
    end
  end
end
