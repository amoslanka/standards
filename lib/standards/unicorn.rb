require "redis"

worker_processes Integer(ENV["UNICORN_WORKERS"] || 3)
timeout Integer(ENV["UNICORN_TIMEOUT"] || 30)
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # Disconnect from ActiveRecord
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # Disconnect from Redis
  defined?(Redis) && Redis.current.quit

end

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  # Reconnect to ActiveRecord
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # Reconnect to Redis
  if defined?(Redis)
    Redis.current.client.connect
    Rails.cache.reconnect if defined?(ActiveSupport::Cache::RedisStore) and 
      Rails.cache.is_a?(ActiveSupport::Cache::RedisStore)
  end

end