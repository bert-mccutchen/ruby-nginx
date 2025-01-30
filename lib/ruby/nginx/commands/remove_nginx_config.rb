# frozen_string_literal: true

require_relative "../constants"
require_relative "../system/safe_file"

module Ruby
  module Nginx
    module Commands
      class RemoveNginxConfig
        include Ruby::Nginx::Constants

        def run(name)
          SafeFile.rm("#{SERVERS_PATH}/#{name}.conf")
        end
      end
    end
  end
end
