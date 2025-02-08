# frozen_string_literal: true

RSpec.describe Ruby::Nginx do
  before do
    Ruby::Nginx.remove!(domain: "example.test")
  end

  it "removes the hosts mapping" do
    hosts = File.read("/etc/hosts")
    expect(hosts).not_to include("example.test")
  end

  it "deletes the NGINX configuration" do
    path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_example_test.conf")
    expect(File.exist?(path)).to be_falsey
  end

  it "successfully tears down a NGINX site" do
    html = `curl -s http://example.test`
    sleep(1) # Sometimes the DNS takes a second to lose the host mapping.
    expect(html).to eq("")
  end
end
