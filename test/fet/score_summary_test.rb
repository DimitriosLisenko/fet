# frozen_string_literal: true

require "test_helper"

module Fet
  class ScoreSummaryTest < Minitest::Test
    def test_summary
      stub_puts do
        stub_scores_filename(scores_fixture) do
          Fet::ScoreSummary.new.summary
        end
      end
    end

    def test_nonexistent_score_summary
      stub_puts do
        stub_scores_filename(nonexistent_scores_fixture) do
          assert_nil(Fet::ScoreSummary.new.summary)
        end
      end
    end

    private

    def stub_puts
      Fet::ScoreSummary.stub_any_instance(:puts, puts_stub) { yield }
    end

    def puts_stub
      return lambda { |value| return value }
    end

    def stub_scores_filename(filename)
      Fet::ScoreSummary.stub(:scores_filename, filename) { yield }
    end

    def scores_fixture
      return File.join(Fet.root, "test", "fet", "fixtures", "scores")
    end

    def nonexistent_scores_fixture
      return File.join(Fet.root, "test", "fet", "fixtures", "chores")
    end
  end
end
