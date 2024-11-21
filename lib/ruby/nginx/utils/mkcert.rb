# frozen_string_literal: true

require "open3"
require_relative "command"
require_relative "safe_file"

module Ruby
  module Nginx
    module Utils
      class Mkcert
        Error = Class.new(StandardError)
        SetupError = Class.new(Error)
        CreateError = Class.new(Error)

        class << self
          def setup!
            Command.new(raise: SetupError).run("mkcert -install")
          end

          def create!(domain, cert_file_path, key_file_path)
            cmd = "mkcert -cert-file #{cert_file_path} -key-file #{key_file_path} #{domain}"
            Command.new(raise: CreateError).run(cmd)
          end
        end
      end
    end
  end
end
