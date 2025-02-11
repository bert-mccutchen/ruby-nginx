# frozen_string_literal: true

require "tty/command"
require_relative "helpers/prompt_helper"
require_relative "helpers/sudo_helper"

module Ruby
  module Nginx
    module Commands
      class TerminalCommand
        include Ruby::Nginx::Commands::Helpers::PromptHelper
        include Ruby::Nginx::Commands::Helpers::SudoHelper

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
        rescue Interrupt
          raise Ruby::Nginx::AbortError, "Operation aborted"
        end
      end
    end
  end
end
