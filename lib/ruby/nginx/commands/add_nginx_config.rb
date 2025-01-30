# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/safe_file"

module Ruby
  module Nginx
    module Commands
      class AddNginxConfig
        include Ruby::Nginx::Constants

        def run(name, config)
          SafeFile.write("#{SERVERS_PATH}/#{name}.conf", config)
        end
      end
    end
  end
end
