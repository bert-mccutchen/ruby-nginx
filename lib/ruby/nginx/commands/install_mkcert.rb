# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class InstallMkcert < TerminalCommand
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

          super(cmd:, raise: Ruby::Nginx::InstallError)
        end

        def run
          super unless installed?
        end

        private

        def installed?
          TTY::Command.new(printer: :null).run!("which mkcert").success?
        end

        def brew_command
          "brew install mkcert nss"
        end

        def yum_command
          "sudo yum install -y nss-tools && " \
          "curl -L -C - \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" -o ./mkcert_download && " \
          "chmod +x ./mkcert_download && " \
          "sudo mv ./mkcert_download /usr/local/bin/mkcert"
        end

        def apt_get_command
          "sudo apt-get install -y libnss3-tools && " \
          "curl -L -C - \"https://dl.filippo.io/mkcert/latest?for=linux/amd64\" -o ./mkcert_download && " \
          "chmod +x ./mkcert_download && " \
          "sudo mv ./mkcert_download /usr/local/bin/mkcert"
        end
      end
    end
  end
end
