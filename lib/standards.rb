require "standards/version"
module Standards

  autoload :BasicHttpAuth, 'standards/basic_http_auth'
  autoload :Cache,         'standards/cache'
  autoload :Cashier,       'standards/cashier'
  autoload :Configs,       'standards/configs'
  autoload :Force,         'standards/force'
  autoload :Resque,        'standards/resque'
  autoload :Statsd,        'standards/statsd'

  def self.basic_http_auth;  BasicHttpAuth; end
  def self.cache;            Cache;         end
  def self.configs;          Configs;       end
  def self.force;            Force;         end
  def self.resque;           Resque;        end
  def self.statsd;           Statsd;        end

end
