# frozen_string_literal: true

require_relative "terminal_command"

module Ruby
  module Nginx
    module Commands
      class CreateMkcertCertificate < TerminalCommand
        def initialize(domain, cert_file_path, key_file_path)
          super(
            cmd: "mkcert -cert-file #{cert_file_path} -key-file #{key_file_path} #{domain}",
            raise: Ruby::Nginx::CreateError
          )
        end
      end
    end
  end
end
