# frozen_string_literal: true

require "test_helper"
require "securerandom"
require "tmpdir"

module Fet
  class GenerateTest < Minitest::Test
    def setup
      @directory_prefix = Dir.mktmpdir
    end

    def teardown
      FileUtils.rm_rf(@directory_prefix)
    end

    def test_generate_listening
      options = {
        exercises: 1, degrees: 1, tempo: 120,
        "all-single-degree": false,
      }
      stub_directory_prefix do
        Fet::Cli::Generate::Listening.run(nil, options, nil)
      end
    end

    def test_generate_single_note_listening
      options = { tempo: 120 }
      stub_directory_prefix do
        Fet::Cli::Generate::SingleNoteListening.run(nil, options, nil)
      end
    end

    def test_generate_singing
      options = { tempo: 120, pause: 3 }
      stub_directory_prefix do
        Fet::Cli::Generate::Singing.run(nil, options, nil)
      end
    end

    def test_generate_singing_via_binary
      capture_subprocess_io do
        stub_directory_prefix do
          load_bin
          App.run(["generate", "singing"])
        end
      end
    end

    def test_generate_listening_via_binary
      capture_subprocess_io do
        stub_directory_prefix do
          load_bin
          App.run(["generate", "listening"])
        end
      end
    end

    def test_generate_single_note_listening_via_binary
      capture_subprocess_io do
        stub_directory_prefix do
          load_bin
          App.run(["generate", "single_note_listening"])
        end
      end
    end

    private

    def stub_directory_prefix
      Fet::Generator::Singing.stub(:directory_prefix, @directory_prefix) do
        Fet::Generator::SingleNoteListening.stub(:directory_prefix, @directory_prefix) do
          Fet::Generator::Listening.stub(:directory_prefix, @directory_prefix) do
            yield
          end
        end
      end
    end
  end
end
