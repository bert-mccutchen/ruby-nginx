# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class SetupMkcert < TerminalCommand
        def initialize
          super(cmd: "mkcert -install", raise: Ruby::Nginx::SetupError)
        end
      end
    end
  end
end
