# frozen_string_literal: true

module Fet
  module Cli
    module Score
      # Defines the CLI "score summary" command
      module SummaryCommand
        def self.included(klass)
          klass.class_eval do
            extend ClassMethods

            desc("Score commands")
            command(:score) do |c|
              define_summary_command(c)
            end
          end
        end

        # Internal methods for the "score summary" command
        module ClassMethods
          private

          def define_summary_command(command)
            command.desc("Show the score summary")
            command.command :summary do |summary|
              define_seconds_flag(summary)
              define_degrees_flag(summary)
              define_key_type_flag(summary)
              define_begin_offset_flag(summary)
              define_end_offset_flag(summary)
              define_score_action(summary)
            end
          end

          def define_seconds_flag(command)
            command.desc("Only include games that had more playtime than the specified amount (seconds)")
            command.default_value(0)
            command.flag([:s, :seconds], type: Integer)
          end

          def define_degrees_flag(command)
            command.desc("Number of degrees to play")
            command.default_value(1)
            command.flag([:d, :degrees], type: Integer, must_match: (1..11).map(&:to_s))
          end

          def define_key_type_flag(command)
            command.desc("Type of the chord progression")
            command.default_value("major")
            command.flag([:k, :"key-type"], type: String, must_match: ["major", "minor"])
          end

          def define_begin_offset_flag(command)
            command.desc("Offset beginning index of resulting array")
            command.default_value(0)
            command.flag([:b, :"begin-offset"], type: Integer)
          end

          def define_end_offset_flag(command)
            command.desc("Offset end index of resulting array")
            command.default_value(0)
            command.flag([:e, :"end-offset"], type: Integer)
          end

          def define_score_action(command)
            command.action do |global_options, options, args|
              Fet::Cli::Score::Summary.run(global_options, options, args)
            end
          end
        end
      end
    end
  end
end
