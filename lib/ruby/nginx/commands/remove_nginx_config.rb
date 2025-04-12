# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/safe_file"

module Ruby
  module Nginx
    module Commands
      class RemoveNginxConfig
        include Ruby::Nginx::Constants

        def initialize(name)
          @name = name
        end

        def run
          return false unless exists?

          Ruby::Nginx::System::SafeFile.rm(config_path)
          true
        end

        private

        def exists?
          Ruby::Nginx::System::SafeFile.exist?(config_path)
        end

        def config_path
          @config_path ||= "#{SERVERS_PATH}/#{@name}.conf"
        end
      end
    end
  end
end
