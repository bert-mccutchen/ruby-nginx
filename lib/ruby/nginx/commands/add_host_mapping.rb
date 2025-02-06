# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class AddHostMapping < TerminalCommand
        def initialize(host, ip, sudo: false)
          @host = host
          @ip = ip
          @sudo = sudo
          sudo_reason = "Allow sudo elevation to add \"#{host}\" to /etc/hosts?"
          cmd = "echo \"#{ip} #{host}\" | #{sudoify("tee -a /etc/hosts", sudo, sudo_reason)}"

          super(cmd:, raise: Ruby::Nginx::ConfigError)
        end

        def run
          super
        rescue Ruby::Nginx::ConfigError
          raise if @sudo

          # Elevate to sudo and try again.
          self.class.new(@host, @ip, sudo: true).run
        end
      end
    end
  end
end
