# frozen_string_literal: true

require "test_helper"

module Fet
  class ScoreSummaryTest < Minitest::Test
    def test_total_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new.summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(218, correct.to_i)
        assert_equal(275, total.to_i)
        assert_equal("79%", percentage)
      end
    end

    def test_minor_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new(key_type: "minor").summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(92, correct.to_i)
        assert_equal(138, total.to_i)
        assert_equal("66%", percentage)
      end
    end

    def test_minimum_session_length_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new(minimum_session_length: 100).summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(211, correct.to_i)
        assert_equal(265, total.to_i)
        assert_equal("79%", percentage)
      end
    end

    def test_number_of_degrees_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new(number_of_degrees: 3).summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(0, correct.to_i)
        assert_equal(0, total.to_i)
        assert_equal("0%", percentage)
      end
    end

    def test_begin_offset_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new(begin_offset: -1).summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(40, correct.to_i)
        assert_equal(60, total.to_i)
        assert_equal("66%", percentage)
      end
    end

    def test_end_offset_summary
      stub_scores_filename(scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new(end_offset: -1).summary }
        assert_empty(err)
        _, correct, total, percentage = parse_table(out, "All")
        assert_equal(178, correct.to_i)
        assert_equal(215, total.to_i)
        assert_equal("82%", percentage)
      end
    end

    def test_nonexistent_score_summary
      stub_scores_filename(nonexistent_scores_fixture) do
        out, err = capture_io { Fet::ScoreSummary.new.summary }
        assert_equal(Fet::ScoreSummary::NO_SCORES_MESSAGE, out.strip)
        assert_empty(err)
      end
    end

    def test_bin_score_summary
      stub_scores_filename(nonexistent_scores_fixture) do
        capture_subprocess_io do
          load_bin
          App.run(["score", "summary"])
        end
      end
    end

    private

    def stub_scores_filename(filename)
      Fet::ScoreSummary.stub(:scores_filename, filename) { yield }
    end

    def scores_fixture
      return File.join(Fet.root, "test", "fet", "fixtures", "scores")
    end

    def nonexistent_scores_fixture
      return File.join(Fet.root, "test", "fet", "fixtures", "chores")
    end

    def parse_table(table, degree)
      table.split("\n")
           .map { |str| str.split("|").map(&:strip).reject(&:empty?) }
           .detect { |arr| arr[0] == degree }
    end
  end
end
