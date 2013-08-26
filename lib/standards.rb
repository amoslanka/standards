require "standards/version"
module Standards

  autoload :Cache,   'standards/cache'
  autoload :Configs, 'standards/configs'
  autoload :Resque,  'standards/resque'
  autoload :Statsd,  'standards/statsd'

  def self.cache;   Cache; end
  def self.configs; Configs; end
  def self.resque;  Resque; end
  def self.statsd;  Statsd; end

end
