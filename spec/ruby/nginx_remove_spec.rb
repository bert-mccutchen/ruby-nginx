# frozen_string_literal: true

RSpec.describe Ruby::Nginx do
  before do
    Ruby::Nginx.remove!(domain: "example.test")
  end

  it "removes the hosts mapping" do
    retry_expectation(limit: 30, delay: 1) do
      hosts = File.read("/etc/hosts")
      expect(hosts).not_to include("example.test")
    end
  end

  it "deletes the NGINX configuration" do
    retry_expectation(limit: 30, delay: 1) do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_example_test.conf")
      expect(File.exist?(path)).to be_falsey
    end
  end

  it "successfully tears down a NGINX site" do
    retry_expectation(limit: 30, delay: 1) do
      html = `curl -s http://example.test`
      expect(html).to eq("")

      html = `curl -s https://example.test`
      expect(html).to eq("")
    end
  end
end
