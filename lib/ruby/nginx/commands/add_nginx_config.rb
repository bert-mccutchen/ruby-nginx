# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/safe_file"

module Ruby
  module Nginx
    module Commands
      class AddNginxConfig
        include Ruby::Nginx::Constants

        def initialize(name, config)
          @name = name
          @config = config
        end

        def run
          return false unless changed?

          Ruby::Nginx::System::SafeFile.write(config_path, @config)
          true
        end

        private

        def changed?
          !Ruby::Nginx::System::SafeFile.exist?(config_path) || (nginx_config != @config)
        end

        def config_path
          @config_path ||= "#{SERVERS_PATH}/#{@name}.conf"
        end

        def nginx_config
          @nginx_config ||= Ruby::Nginx::System::SafeFile.read(config_path)
        end
      end
    end
  end
end
