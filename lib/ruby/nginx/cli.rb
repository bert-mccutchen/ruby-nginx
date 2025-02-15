# frozen_string_literal: true

require "thor"
require_relative "../nginx"

module Ruby
  module Nginx
    class CLI < Thor
      include Thor::Actions

      FAKE_CONFIG = Ruby::Nginx::Configuration.new(domain: "[DOMAIN]")

      def self.defaults(param)
        "default: #{FAKE_CONFIG.defaults[param]}"
      end

      def self.default_paths(param)
        "default: #{FAKE_CONFIG.default_paths[param]}"
      end

      desc "add", "Add a NGINX server configuration"
      method_option :domain, aliases: "-d", type: :string, required: true, desc: "eg. example.test"
      method_option :port, aliases: "-p", type: :numeric, required: true, desc: "eg. 3000"
      method_option :host, aliases: "-h", type: :string, desc: defaults(:host)
      method_option :root_path, aliases: "-r", type: :string, desc: "default: $PWD"
      method_option :ssl, aliases: "-s", type: :boolean, desc: defaults(:ssl)
      method_option :log, aliases: "-l", type: :boolean, desc: defaults(:log)
      method_option :template_path, aliases: "-t", type: :string, desc: "default: [GEM_PATH]/nginx/templates/nginx.conf"
      method_option :ssl_certificate_path, aliases: "-cert-file", type: :string, desc: default_paths(:ssl_certificate_path)
      method_option :ssl_certificate_key_path, aliases: "-key-file", type: :string, desc: default_paths(:ssl_certificate_key_path)
      method_option :access_log_path, aliases: "-access-log", type: :string, desc: default_paths(:access_log_path)
      method_option :error_log_path, aliases: "-error-log", type: :string, desc: default_paths(:error_log_path)
      def add
        config = {
          domain: options.domain,
          port: options.port,
          host: options.host,
          root_path: options.root_path,
          template_path: options.template_path,
          ssl: options.ssl,
          log: options.log,
          ssl_certificate_path: options.ssl_certificate_path,
          ssl_certificate_key_path: options.ssl_certificate_key_path,
          access_log_path: options.access_log_path,
          error_log_path: options.error_log_path
        }.compact

        Ruby::Nginx.add!(**config)
      rescue Ruby::Nginx::Error => e
        abort "[Ruby::Nginx] #{e.message}"
      end

      desc "remove", "Remove a NGINX server configuration"
      method_option :domain, aliases: "-d", type: :string, required: true, desc: "eg. example.test"
      def remove
        Ruby::Nginx.remove!(domain: options.domain)
      rescue Ruby::Nginx::Error => e
        abort "[Ruby::Nginx] #{e.message}"
      end
    end
  end
end
