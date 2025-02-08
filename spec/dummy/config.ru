require "rack"

app = Rack::Builder.new do
  use Rack::Static, index: "index.html"

  run do |env|
    [200, {"Content-Type" => "text/html"}, File.open("index.html", File::RDONLY)]
  end
end

run app
