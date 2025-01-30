# frozen_string_literal: true

require_relative "../commands/add_host_mapping"
require_relative "../commands/remove_host_mapping"

module Ruby
  module Nginx
    module System
      class Hosts
        class << self
          def add(host, ip)
            remove(host)
            Commands::AddHostMapping.new(host, ip).run.success?
          end

          def remove(host)
            Commands::RemoveHostMapping.new(host).run.success?
          end
        end
      end
    end
  end
end
