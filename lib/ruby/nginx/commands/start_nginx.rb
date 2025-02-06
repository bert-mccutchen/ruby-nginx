# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class StartNginx < TerminalCommand
        def initialize(sudo: false)
          @sudo = sudo
          sudo_reason = "Allow sudo elevation to start nginx?"
          cmd = sudoify("nginx", sudo, sudo_reason)

          super(cmd:, raise: Ruby::Nginx::StartError)
        end

        def run
          super
        rescue Ruby::Nginx::StartError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(sudo: true).run
        end
      end
    end
  end
end
