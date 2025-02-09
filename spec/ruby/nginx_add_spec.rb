# frozen_string_literal: true

require "puma/configuration"

RSpec.describe Ruby::Nginx do
  before(:all) do
    Ruby::Nginx.add!(
      domain: "example.test",
      port: Puma::Configuration::DEFAULTS[:tcp_port],
      root_path: RSpec.configuration.dummy_path,
      ssl: true,
      log: true
    )
  end

  it "adds the hosts mapping" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      hosts = File.read("/etc/hosts")
      expect(hosts).to include("example.test")
    end
  end

  it "creates the NGINX configuration" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_example_test.conf")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the SSL certificate" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/certs/_example.test.pem")
      expect(File.exist?(path)).to be_truthy

      path = File.expand_path("~/.ruby-nginx/certs/_example.test-key.pem")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the log files" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/logs/example.test.access.log")
      expect(File.exist?(path)).to be_truthy

      path = File.expand_path("~/.ruby-nginx/logs/example.test.error.log")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "successfully builds up a NGINX site" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      html = `curl -s http://example.test`
      expect(html).to include("Hello, from Ruby NGINX!")

      html = `curl -s https://example.test`
      expect(html).to include("Hello, from Ruby NGINX!")
    end
  end
end
