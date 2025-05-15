# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class StopNginx < TerminalCommand
        def initialize(sudo: false)
          @sudo = sudo
          sudo_reason = "Allow sudo elevation to stop NGINX?"

          super(cmd: sudoify("nginx -s stop", sudo, sudo_reason), raise: Ruby::Nginx::StopError)
        end

        def run
          super
        rescue Ruby::Nginx::StopError => e
          return if nginx_not_running_error?(e)

          if @sudo
            raise
          else
            # Elevate to sudo and try again.
            self.class.new(sudo: true).run
          end
        end

        private

        def nginx_not_running_error?(error)
          error.message.include?("invalid PID number") ||
            error.message.include?("No such process") ||
            error.message.include?("No such file or directory")
        end
      end
    end
  end
end
