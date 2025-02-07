# frozen_string_literal: true

RSpec.describe Ruby::Nginx do
  before do
    Ruby::Nginx.add!(
      domain: "example.test",
      port: 3000,
      root_path: "#{File.dirname(__FILE__)}/../dummy",
      ssl: true,
      log: true
    )
  end

  it "adds the hosts mapping" do
    hosts = File.read("/etc/hosts")
    expect(hosts).to include("example.test")
  end

  it "creates the NGINX configuration" do
    path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_example_test.conf")
    expect(File.exist?(path)).to be_truthy
  end

  it "creates the SSL certificate" do
    path = File.expand_path("~/.ruby-nginx/certs/_example.test.pem")
    expect(File.exist?(path)).to be_truthy

    path = File.expand_path("~/.ruby-nginx/certs/_example.test-key.pem")
    expect(File.exist?(path)).to be_truthy
  end

  it "creates the log files" do
    path = File.expand_path("~/.ruby-nginx/logs/example.test.access.log")
    expect(File.exist?(path)).to be_truthy

    path = File.expand_path("~/.ruby-nginx/logs/example.test.error.log")
    expect(File.exist?(path)).to be_truthy
  end

  it "successfully builds up a NGINX site" do
    html = `curl -s http://example.test/index.html`
    expect(html).to include("Hello, from Ruby NGINX!")
  end
end
