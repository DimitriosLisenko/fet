# frozen_string_literal: true

module Fet
  module Cli
    module Play
      # CLI implementation for the "play listening" command
      module Listening
        def self.run(_global_options, options, _args)
          Fet::Ui::Game.new(
            tempo: options[:tempo],
            degrees: options[:degrees],
            key_type: options[:"key-type"],
            next_on_correct: options[:"next-on-correct"],
          ).start
        end
      end
    end
  end
end
