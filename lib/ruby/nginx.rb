# frozen_string_literal: true

require_relative "nginx/configuration"
require_relative "nginx/utils/nginx"
require_relative "nginx/version"

module Ruby
  module Nginx
    class Error < StandardError; end

    def self.add!(options = {}, &block)
      conf = config(options, &block)

      Utils::Nginx.add_server_config(conf.name, conf.generate!)
      Utils::Nginx.validate_config!
      Utils::Nginx.restart!

      conf
    rescue Utils::Nginx::Error
      remove!
      raise
    end

    def self.remove!(options = {}, &block)
      conf = config(options, &block)

      Utils::Nginx.remove_server_config(conf.name)
      Utils::Nginx.restart!

      conf
    end

    private

    def self.config(options = {})
      conf = Configuration.new(options)

      yield conf if block_given?

      conf
    end
    private_class_method :config
  end
end
