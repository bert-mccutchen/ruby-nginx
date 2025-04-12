# frozen_string_literal: true

require_relative "../commands/add_nginx_config"
require_relative "../commands/install_nginx"
require_relative "../commands/nginx_options"
require_relative "../commands/nginx_version"
require_relative "../commands/remove_nginx_config"
require_relative "../commands/setup_nginx"
require_relative "../commands/start_nginx"
require_relative "../commands/stop_nginx"
require_relative "../commands/validate_nginx_config"

module Ruby
  module Nginx
    module System
      class Nginx
        class << self
          def version
            Commands::NginxVersion.new.run
          end

          def options
            Commands::NginxOptions.new.run
          end

          def install!
            Commands::InstallNginx.new.run
          end

          def setup!
            Commands::SetupNginx.new.run
          end

          def add_server_config(name, config)
            Commands::AddNginxConfig.new(name, config).run
          end

          def remove_server_config(name)
            Commands::RemoveNginxConfig.new(name).run
          end

          def validate_config!
            Commands::ValidateNginxConfig.new.run
          end

          def start!
            Commands::StartNginx.new.run
          end

          def stop!
            Commands::StopNginx.new.run
          end

          def restart!
            stop!
            start!
          end
        end
      end
    end
  end
end
