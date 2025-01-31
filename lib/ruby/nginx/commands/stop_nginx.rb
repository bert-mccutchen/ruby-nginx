# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class StopNginx < TerminalCommand
        def initialize(sudo: false)
          @sudo = sudo
          cmd = sudoify("nginx -s stop", sudo)

          super(cmd:, raise: Ruby::Nginx::StopError)
        end

        def run
          super
        rescue Ruby::Nginx::StopError => e
          if @sudo
            # Nginx is not running - ignore.
            raise unless e.message.include?("invalid PID number")
          else
            # Elevate to sudo and try again.
            self.class.new(sudo: true).run
          end
        end
      end
    end
  end
end
