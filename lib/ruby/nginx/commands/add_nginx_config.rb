# frozen_string_literal: true

require_relative "../utils/safe_file"

module Ruby
  module Nginx
    module Commands
      class AddNginxConfig
        def run(name, config)
          SafeFile.write("#{CONFIG_DIRECTORY_PATH}/#{name}.conf", config)
        end
      end
    end
  end
end
