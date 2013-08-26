# Override some behavior
class Statsd
  cattr_accessor :current
end

host = ENV['STATSD_HOST'] || 'localhost'
port = ENV['STATSD_PORT'] || 8125

Statsd.current = Statsd.new(host, port)

# Namespace our stats to our environment.
Statsd.current.tap{ |sd| sd.namespace = Rails.env } unless Rails.env.production?
