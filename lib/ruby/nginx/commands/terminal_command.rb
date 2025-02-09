# frozen_string_literal: true

require "tty/command"
require "tty/prompt"

module Ruby
  module Nginx
    module Commands
      class TerminalCommand
        attr_reader :cmd, :user, :error_type, :printer, :result

        def initialize(cmd:, user: nil, raise: nil, printer: :null)
          @cmd = cmd
          @user = user
          @error_type = raise
          @printer = ENV["DEBUG"] ? :pretty : printer
          @result = nil
        end

        def run
          @result = TTY::Command.new(printer: printer).run!(cmd, user: user)
          raise @error_type, @result.err if error_type && @result.failure?

          @result
        end

        protected

        def yes?(question)
          ENV["SKIP_PROMPT"] || TTY::Prompt.new.yes?("[Ruby::Nginx] #{question}")
        end

        def sudoify(cmd, sudo, reason)
          return cmd unless sudo

          if sudo_access? || yes?(reason)
            "sudo #{cmd}"
          else
            raise Ruby::Nginx::AbortError, "Operation aborted"
          end
        end

        private

        def sudo_access?
          TerminalCommand.new(cmd: "sudo -n true").run.success?
        end
      end
    end
  end
end
