# Ruby NGINX

Utility gem with an added CLI for setting up reverse proxies with custom domains. Because sometimes you just don't want to use containers, or your platform doesn't natively run containers without a virtual machine - I'm looking at you - Darwin.

:heart: ERB for NGINX configuration templating.

:yellow_heart: Self-signed certificate generation via mkcert for HTTPS.

:green_heart: Tried and true NGINX for reverse proxying, and hosts mapping for DNS.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

---

### Key Features

The aim of this gem is to be easy to use, while keeping the user in control of their own machine. With Ruby NGINX's automation, you should feel comfortable, informed, and in control of the process.

- Automated installation of NGINX and mkcert that are entirely optional.
  - You will be prompted before installation. You may reject installation to install NGINX or mkcert on your own terms.
- Sudo - only when necessary, and on your own terms.
  - By default, all attempts to configure or interact with NGINX, /etc/hosts, and mkcert, are done without elevated privileges. Sudo is only used when the initial attempt fails with your users privileges.
  - You will be prompted to accept sudo elevation, and why it is required. Rejection will immediately abort the process.
- Isolated NGINX configuration.
  - Your NGINX configuration will automatically be updated to include configuration files from `~/.ruby-nginx/servers`. This ensures a clean separation exists between your personal NGINX configuration and Ruby NGINX's automation.
- Cross-platform and support for multiple package managers.
  - macOS - brew
  - Linux - apt-get, pacman (soon), yum, zypper (soon)
- Complete configuration - everything is configurable. You can even bring your own NGINX config, and if you'd like, your own :beers:.

> [!WARNING]
>This gem is intended to be an aid to your development environment - complemented by [Rails NGINX](https://github.com/bert-mccutchen/rails-nginx). **Don't use this gem in production.**

---

### Contents

- [Installation](#installation)
- [Library Usage](#library-usage)
  - [Adding an NGINX configuration](#adding-an-nginx-configuration)
  - [Removing an NGINX configuration](#removing-an-nginx-configuration)
- [CLI Usage](#cli-usage)
  - [Help](#help)
  - [Adding an NGINX configuration](#adding-an-nginx-configuration-1)
  - [Removing an NGINX configuration](#removing-an-nginx-configuration-1)
- [Development](#development)
  - [Setup](#setup)
  - [Lint / Test](#lint--test)
  - [Debug Console](#debug-console)
  - [CLI Executable](#cli-executable)
  - [Release](#release)
- [Contributing](#contributing)
- [License](#license)

## Installation

Install via Bundler:
```bash
bundle add ruby-nginx
```

Or install it manually:
```bash
gem install ruby-nginx
```

## Library Usage

### Adding an NGINX configuration

You can pass configuration options directly.
```ruby
Ruby::Nginx.add!(
  # required
  domain: "example.test",

  # required
  port: 3000,

  # default: 127.0.0.1
  host: "localhost",

  # default: [packaged template]
  template_path: "~/projects/example-app/nginx.conf.erb",

  # default: $PWD
  root_path: "~/projects/example-app/public",

  # default: false
  ssl: true,

  # default: false
  log: true,

  # default: ~/.ruby-nginx/certs/_[DOMAIN].pem
  ssl_certificate_path: "~/projects/example-app/tmp/nginx/_example.test.pem",

  # default: ~/.ruby-nginx/certs/_[DOMAIN]-key.pem
  ssl_certificate_key_path: "~/projects/example-app/tmp/nginx/_example.test-key.pem",

  # default: ~/.ruby-nginx/logs/[DOMAIN].access.log
  access_log_path: "~/projects/example-app/log/nginx/example.test.access.log",

  # default: ~/.ruby-nginx/logs/[DOMAIN].error.log
  error_log_path: "~/projects/example-app/log/nginx/example.test.error.log"
)
```

OR you can interact with the configuration object via a block.
```ruby
Ruby::Nginx.add! do |config|
  config.options[:domain] = "example.test"
  config.options[:port] = 3000
  # etc.
end
```

### Removing an NGINX configuration

You can pass configuration options directly.
```ruby
Ruby::Nginx.remove!(domain: "example.test")
```

OR you can interact with the configuration object via a block. However, only domain is used during removal - all other options are ignored.
```ruby
Ruby::Nginx.remove! do |config|
  config.options[:domain] = "example.test"
end
```

## CLI Usage

### Help

To print the help text.
```
>ruby-nginx help
Commands:
  ruby-nginx add -d, --domain=DOMAIN -p, --port=N  # Add a NGINX server configuration
  ruby-nginx help [COMMAND]                        # Describe available commands or one specific command
  ruby-nginx remove -d, --domain=DOMAIN            # Remove a NGINX server configuration
```

### Adding an NGINX configuration

```
> ruby-nginx help add
Usage:
  ruby-nginx add -d, --domain=DOMAIN -p, --port=N

Options:
  -d,          --domain=DOMAIN                                        # eg. example.test
  -p,          --port=N                                               # eg. 3000
  -h,          [--host=HOST]                                          # default: 127.0.0.1
  -r,          [--root-path=ROOT_PATH]                                # default: $PWD
  -s,          [--ssl], [--no-ssl], [--skip-ssl]                      # default: false
  -l,          [--log], [--no-log], [--skip-log]                      # default: false
  -cert-file,  [--ssl-certificate-path=SSL_CERTIFICATE_PATH]          # default: ~/.ruby-nginx/certs/_[DOMAIN].pem
  -key-file,   [--ssl-certificate-key-path=SSL_CERTIFICATE_KEY_PATH]  # default: ~/.ruby-nginx/certs/_[DOMAIN]-key.pem
  -access-log, [--access-log-path=ACCESS_LOG_PATH]                    # default: ~/.ruby-nginx/logs/[DOMAIN].access.log
  -error-log,  [--error-log-path=ERROR_LOG_PATH]                      # default: ~/.ruby-nginx/logs/[DOMAIN].error.log

Add a NGINX server configuration
```

### Removing an NGINX configuration

```
> ruby-nginx help remove
Usage:
  ruby-nginx remove -d, --domain=DOMAIN

Options:
  -d, --domain=DOMAIN  # eg. example.test

Remove a NGINX server configuration
```

## Development

### Setup

Install development dependencies.
```
./bin/setup
```

### Lint / Test

Run the Standard Ruby linter, and RSpec test suite.
```
bundle exec rake
```

### Debug Console

Start an interactive Ruby console (IRB).
```
./bin/console
```

### CLI Executable

Run the gem's Thor CLI directly.
```
./exe/ruby-nginx
```

OR build and install the gem to your local machine.
```
bundle exec rake install
ruby-nginx help
```

### Release

A new release will automatically be built and uploaded to RubyGems by a [GitHub Actions workflow](./.github/workflows/gem-push.yml) upon the push of a new Git tag.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/ruby-nginx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
