Standards
---------

A collection of Rails utilities and helpers that we routinely use. 

Installation
------------

Add this line to your application's Gemfile:

    gem 'standards', git: 'https://github.com/amoslanka/standards.git'

Tools and Utilities
-------------------

### Cache

Clears the Rails cache.

__add to your Rakefile__

    require 'standards/resque'

Use it on demand:

    rake cache:clear

    rake cache:flush # (alias for cache:clear)

### Configs

Provides a number of methods for pulling configurations out of ENV and other configuration locations based on standardized names.

Each configs method will return a hash. 

##### Methods

`smtp`: `smtp`: Standard smtp settings for the ActionMailer smtp_settings configuration. 

__add to your config/application.rb (or environment configuration)__

    config.action_mailer.smtp_settings = Standards.configs.smtp

- SMTP_ADDRESS
- SMTP_USER_NAME
- SMTP_PASSWORD
- SMTP_PORT                 (default: 587)
- SMTP_AUTHENTICATION       (default: 'plain')
- SMTP_ENABLE_STARTTLS_AUTO
- SMTP_OPENSSL_VERIFY_MODE
- SMTP_DOMAIN

The smtp method will automatically fill in values when env configurations are recognized. For example, the smtp servers for gmail and sendgrid use different ports, and the config will set the correct port if no port is specified.

### Resque

Provides a standard resque worker task. 

__add to your Rakefile__

    require 'standards/resque'

__Procfile (or in a terminal)__

    worker:    bundle exec rake resque:setup resque:work QUEUE='*'

### Statsd

Configures the [Statsd client](http://rubygems.org/gems/statsd-ruby) from environment variables and sets a `Statsd.current` class attribute to access the current connection instance.

__add to your Gemfile__

    gem 'statsd-ruby'

__config/initializers/statsd.rb__

    require 'standards/statsd'

### Unicorn

Defines a standard unicorn configuration. Automatically detects connections that may need to be reestablished on forks.

__config/unicorn.rb (or whatever your unicorn config file is)__

    require 'standards/unicorn'

__Procfile (or in a terminal)__

    web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

##### Reconnections

The following are automatic service connections made on the unicorn after_fork callback:

- ActiveRecord: `ActiveRecord::Base.establish_connection`
- Redis: `Redis.current.connect`
- Cache: `Rails.cache.reconnect` (only if the cache store is an instance of ActiveSupport::Cache::RedisStore)

The following are automatic service disconnections made on the unicorn before_fork callback:

- `ActiveRecord::Base.connection.disconnect!`
- `Redis.current.quit`

Roadmap
-------

- Configurations: Sendgrid
- Configurations: SMTP
- S3 Storage/Carrierwave 
- Doctor task
- Deploy task (primarily for git deployment), including config writer for deploy environments 
- Sprite generation and "autosprite" task. Pngquant and imageoptim.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
