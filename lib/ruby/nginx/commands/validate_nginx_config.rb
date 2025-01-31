# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class ValidateNginxConfig < TerminalCommand
        def initialize(sudo: false)
          @sudo = sudo
          cmd = sudoify("nginx -t", sudo)

          super(cmd:, raise: Ruby::Nginx::ConfigError)
        end

        def run
          super
        rescue Ruby::Nginx::ConfigError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(sudo: true).run
        end
      end
    end
  end
end
