# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class InstallNginx < TerminalCommand
        def initialize
          cmd =
            case package_manager
            when :brew
              brew_command
            when :apt_get
              apt_get_command
            when :yum
              yum_command
            end

          super(cmd:, raise: Ruby::Nginx::InstallError, printer: :pretty)
        end

        def run
          return if installed?

          if yes?("Would you like to install Nginx?")
            super
          else
            raise Ruby::Nginx::AbortError, "Nginx is required to continue. Please install Nginx."
          end
        end

        private

        def installed?
          TTY::Command.new(printer: :null).run!("which nginx").success?
        end

        def brew_command
          "brew install nginx"
        end

        def yum_command
          "sudo yum install -y nginx"
        end

        def apt_get_command
          "sudo apt-get install -y nginx"
        end
      end
    end
  end
end
