require 'cashier'
require 'redis-namespace'

# 
# Configures Cashier to store in redis, use the current redis instance,
# and namespace the store with "cashier"
module Standards
  module Cashier

    # 
    # Cashier enables tag based caching.
    Cashier.adapter = :redis_store
    Cashier.adapter.redis = Redis::Namespace.new(:cashier, :redis => Redis.current)

    # Subscribe to the store fragment event, this is fired every time cashier will call the "store_fragment" method
    # payload[:data] will be something like this: ["key", ["tag1", "tag2", "tag3"]]
    ActiveSupport::Notifications.subscribe("store_fragment.cashier") do |name, start, finish, id, payload|
      Rails.logger.tagged 'cache' do
        keys = payload[:data].first rescue nil
        tags = payload[:data].second rescue nil
        Rails.logger.debug "[cashier] notifications=#{name} #{keys}"
      end
    end

    # Subscribe to the clear event. (no data)
    ActiveSupport::Notifications.subscribe("clear.cashier") do |name, start, finish, id, payload|
      Rails.logger.tagged 'cache' do
        Rails.logger.debug "[cashier] notifications=#{name}"
      end
    end 

    # Subscribe to the expire event. 
    ActiveSupport::Notifications.subscribe("expire.cashier") do |name, start, finish, id, payload|
      Rails.logger.tagged 'cache' do
        tags = payload[:data] rescue nil
        Rails.logger.debug "[cashier] notifications=#{name} #{tags}"
      end
    end 

    # Subscribe to the delete_cache_key event
    # this event will fire every time there's a Rails.cache.delete with the key
    # payload[:data] will be the key name that's been deleted from the cache
    ActiveSupport::Notifications.subscribe("delete_cache_key.cashier") do |name, start, finish, id, payload|
      Rails.logger.tagged 'cache' do
        keys = payload[:data] rescue nil
        Rails.logger.info "[cashier] notifications=#{name} #{keys}"
      end
    end

    # Subscribe to the o_write_cache_key event
    # this event will fire every time there's a Rails.cache.write with the key
    # payload[:data] will be the key name that's been written to the cache
    ActiveSupport::Notifications.subscribe("write_cache_key.cashier") do |name, start, finish, id, payload|
      Rails.logger.tagged 'cache' do
        keys = payload[:data] rescue nil
        Rails.logger.info "[cashier] notifications=#{name} #{keys}"
      end
    end 

  end
end