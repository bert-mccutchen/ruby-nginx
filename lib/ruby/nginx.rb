# frozen_string_literal: true

require_relative "nginx/configuration"
require_relative "nginx/exceptions"
require_relative "nginx/system/hosts"
require_relative "nginx/system/nginx"
require_relative "nginx/version"

module Ruby
  module Nginx
    include Ruby::Nginx::Exceptions

    def self.add!(options = {}, &block)
      setup!
      conf = config(options, &block)

      System::Nginx.add_server_config(conf.name, conf.generate!)
      System::Nginx.validate_config!
      System::Nginx.restart!
      System::Hosts.add(conf.domain, conf.host)

      conf
    rescue Ruby::Nginx::AbortError
      raise
    rescue Ruby::Nginx::Error
      remove!(options)
      raise
    end

    def self.remove!(options = {}, &block)
      conf = config(options, &block)

      System::Nginx.remove_server_config(conf.name)
      System::Nginx.restart!
      System::Hosts.remove(conf.domain)

      conf
    end

    private

    def self.setup!
      System::Nginx.install!
      System::Nginx.setup!
      System::Mkcert.install!
      System::Mkcert.setup!
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
