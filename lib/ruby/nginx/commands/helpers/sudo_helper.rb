# frozen_string_literal: true

require "tty/command"
require_relative "prompt_helper"

module Ruby
  module Nginx
    module Commands
      module Helpers
        module SudoHelper
          include Ruby::Nginx::Commands::Helpers::PromptHelper

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
end
