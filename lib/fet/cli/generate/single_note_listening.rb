# frozen_string_literal: true

module Fet
  module Cli
    module Generate
      # CLI implementation for the "generate single_note_listening" command
      module SingleNoteListening
        def self.run(_global_options, options, _args)
          Fet::Generator::SingleNoteListening.new(
            tempo: options[:tempo],
            directory_prefix: options[:directory_prefix],
          ).generate
        end
      end
    end
  end
end
