# frozen_string_literal: true

module Ruby
  module Nginx
    module Commands
      class RemoveNginxConfig
        def run(name)
          FileUtils.rm_f("#{CONFIG_DIRECTORY_PATH}/#{name}.conf")
        end
      end
    end
  end
end
