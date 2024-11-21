# Ruby NGINX

Utility gem with an added CLI for configuring NGINX with SSL.

1. ERB for NGINX configuration templating.
2. Mkcert for SSL certificate generation.
3. Tried and true NGINX for reverse proxying.

This gem is intended to be an aid to your development environment - complemented by [Rails NGINX](https://github.com/bert-mccutchen/rails-nginx). **Don't use this in production.**

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

## Installation

Install via Bundler:
```bash
bundle add ruby-nginx
```

Or install it manually:
```bash
gem install ruby-nginx
```

## Usage

### Library Usage

#### Adding an NGINX configuration
```ruby
Ruby::Nginx.add!(
  # required
  domain: "example.test",

  # required
  port: 3000,

  # default: 127.0.0.1
  host: "localhost",

  # default: included template
  template_path: "$HOME/projects/example-app/nginx.conf.erb",

  # default: $PWD
  root_path: "$HOME/projects/example-app/public",

  # default: false
  ssl: true,

  # default: false
  log: true,

  # default: ~/.ruby-nginx/certs/_[DOMAIN].pem
  ssl_certificate_path: "$HOME/projects/example-app/tmp/nginx/_example.test.pem",

  # default: ~/.ruby-nginx/certs/_[DOMAIN]-key.pem
  ssl_certificate_key_path: "$HOME/projects/example-app/tmp/nginx/_example.test-key.pem",

  # default: ~/.ruby-nginx/logs/[DOMAIN].access.log
  access_log_path: "$HOME/projects/example-app/log/nginx/example.test.access.log",

  # default: ~/.ruby-nginx/logs/[DOMAIN].error.log
  error_log_path: "$HOME/projects/example-app/log/nginx/example.test.error.log"
)
```

#### Removing an NGINX configuration
```ruby
Ruby::Nginx.remove!(domain: "example.test")
```

### CLI Usage

#### Adding an NGINX configuration
```
Usage:
  ruby-nginx add -d, --domain=DOMAIN -p, --port=N

Options:
  -d,          --domain=DOMAIN                                        # eg. your-app.test
  -p,          --port=N                                               # eg. 3000
  -h,          [--host=HOST]                                          # default: 127.0.0.1
  -r,          [--root-path=ROOT_PATH]                                # default: $PWD
  -s,          [--ssl], [--no-ssl], [--skip-ssl]                      # default: false
  -l,          [--log], [--no-log], [--skip-log]                      # default: false
  -cert-file,  [--ssl-certificate-path=SSL_CERTIFICATE_PATH]          # default: ~/.ruby-nginx/certs/_[DOMAIN].pem
  -key-file,   [--ssl-certificate-key-path=SSL_CERTIFICATE_KEY_PATH]  # default: ~/.ruby-nginx/certs/_[DOMAIN]-key.pem
  -access-log, [--access-log-path=ACCESS_LOG_PATH]                    # default: ~/.ruby-nginx/logs/[DOMAIN].access.log
  -error-log,  [--error-log-path=ERROR_LOG_PATH]                      # default: ~/.ruby-nginx/logs/[DOMAIN].error.log
```

#### Removing an NGINX configuration
```
Usage:
  ruby-nginx remove -d, --domain=DOMAIN

Options:
  -d, --domain=DOMAIN  # eg. your-app.test
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/ruby-nginx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
