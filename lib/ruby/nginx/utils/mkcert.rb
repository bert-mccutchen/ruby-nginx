# frozen_string_literal: true

require_relative "commands/install_mkcert"
require_relative "commands/setup_mkcert"
require_relative "commands/create_mkcert_certificate"

module Ruby
  module Nginx
    module Utils
      class Mkcert
        class << self
          def install!
            Commands::InstallMkcert.new.run
          end

          def setup!
            Commands::SetupMkcert.new.run
          end

          def create!(domain, cert_file_path, key_file_path)
            Commands::CreateMkcertCertificate.new(domain, cert_file_path, key_file_path).run
          end
        end
      end
    end
  end
end
