# frozen_string_literal: true

require_relative "lib/ruby/nginx/version"

Gem::Specification.new do |spec|
  spec.name = "ruby-nginx"
  spec.version = Ruby::Nginx::VERSION
  spec.authors = ["Bert McCutchen"]
  spec.email = ["mail@bertm.dev"]

  spec.summary = "Utility for configuring NGINX with SSL."
  spec.description = "Utility gem with an added CLI for configuring NGINX with SSL."
  spec.homepage = "https://github.com/bert-mccutchen/ruby-nginx"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bert-mccutchen/ruby-nginx"
  spec.metadata["changelog_uri"] = "https://github.com/bert-mccutchen/ruby-nginx/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir["CHANGELOG.md", "LICENSE.txt", "README.md", "docs/*", "exe/*", "lib/**/*"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "erb"
  spec.add_dependency "thor"
  spec.add_dependency "tty-command", "~> 0.10", ">= 0.10.1"
  spec.add_dependency "tty-prompt", ">= 0.3.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
