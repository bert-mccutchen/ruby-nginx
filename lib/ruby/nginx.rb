# frozen_string_literal: true

require_relative "nginx/configuration"
require_relative "nginx/utils/hosts"
require_relative "nginx/utils/nginx"
require_relative "nginx/version"

module Ruby
  module Nginx
    CONFIG_DIRECTORY_PATH = "$HOME/.ruby-nginx/servers"

    Error = Class.new(StandardError)
    PackageManagerError = Class.new(Error)
    InstallError = Class.new(Error)
    SetupError = Class.new(Error)
    CreateError = Class.new(Error)
    ConfigError = Class.new(Error)
    StartError = Class.new(Error)
    StopError = Class.new(Error)

    def self.add!(options = {}, &block)
      setup!
      conf = config(options, &block)

      Utils::Nginx.add_server_config(conf.name, conf.generate!)
      Utils::Nginx.validate_config!
      Utils::Nginx.restart!
      Utils::Hosts.add(conf.domain, conf.host)

      conf
    rescue Utils::Nginx::Error
      remove!
      raise
    end

    def self.remove!(options = {}, &block)
      conf = config(options, &block)

      Utils::Nginx.remove_server_config(conf.name)
      Utils::Nginx.restart!
      Utils::Hosts.remove(conf.domain)

      conf
    end

    private

    def self.setup!
      Utils::Nginx.install!
      Utils::Nginx.setup!
      Utils::Mkcert.install!
      Utils::Mkcert.setup!
    end
    private_class_method :setup!

    def self.config(options = {})
      conf = Configuration.new(options)

      yield conf if block_given?

      conf
    end
    private_class_method :config
  end
end
