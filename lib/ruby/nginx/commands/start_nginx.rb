# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class StartNginx < TerminalCommand
        def initialize
          super(cmd: "sudo nginx", raise: Ruby::Nginx::StartError)
        end
      end
    end
  end
end
