# frozen_string_literal: true

require "erb"
require_relative "constants"
require_relative "system/mkcert"
require_relative "system/nginx"
require_relative "system/safe_file"

module Ruby
  module Nginx
    class Configuration
      include Ruby::Nginx::Constants

      attr_accessor :options

      def initialize(options = {})
        @options = defaults.merge(options)
      end

      def domain
        options[:domain]
      end

      def host
        options[:host]
      end

      def name
        "ruby_nginx_#{options[:domain].gsub(/\W/, "_")}"
      end

      def generate!
        validate!
        apply_dynamic_defaults!

        create_temp_path!
        create_ssl_certs! if options[:ssl]
        create_log_files! if options[:log]

        ERB.new(load_template).result(binding)
      end

      def defaults
        {
          host: "127.0.0.1",
          root_path: Dir.pwd,
          template_path: File.expand_path("templates/nginx.conf.erb", __dir__),
          ssl: false,
          log: false
        }
      end

      def default_paths
        {
          temp_path: default_path("tmp"),
          ssl_certificate_path: default_path("certs/_#{options[:domain]}.pem"),
          ssl_certificate_key_path: default_path("certs/_#{options[:domain]}-key.pem"),
          access_log_path: default_path("logs/#{options[:domain]}.access.log"),
          error_log_path: default_path("logs/#{options[:domain]}.error.log")
        }
      end

      def nginx_version
        @nginx_version ||= System::Nginx.version
      end

      private

      def default_path(path)
        "#{CONFIG_PATH}/#{path}"
      end

      def realize_option_path!(option)
        options[option] = System::SafeFile.touch(options[option])
      end

      def validate!
        raise ArgumentError, "domain is required" unless options[:domain]
        raise ArgumentError, "port is required" unless options[:port]
        raise ArgumentError, "template_path is required" unless options[:template_path]
      end

      def apply_dynamic_defaults!
        self.options = default_paths.merge(options)
      end

      def load_template
        File.read(options[:template_path])
      rescue Errno::EISDIR
        raise Ruby::Nginx::AbortError, "Template is a directory: #{options[:template_path]}"
      rescue Errno::ENOENT
        raise Ruby::Nginx::AbortError, "Template does not exist at: #{options[:template_path]}"
      rescue => e
        raise Ruby::Nginx::AbortError, "Failed to read template.", cause: e
      end

      def create_temp_path!
        options[:temp_path] = System::SafeFile.mkdir(options[:temp_path])
      end

      def create_ssl_certs!
        System::Mkcert.create!(
          options[:domain],
          realize_option_path!(:ssl_certificate_path),
          realize_option_path!(:ssl_certificate_key_path)
        )
      end

      def create_log_files!
        realize_option_path!(:access_log_path)
        realize_option_path!(:error_log_path)
      end
    end
  end
end
