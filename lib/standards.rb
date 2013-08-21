require "standards/version"
module Standards

  autoload :Cache,   'standards/cache'
  autoload :Configs, 'standards/configs'
  autoload :Resque,  'standards/resque'

  def cache;   Cache; end
  def configs; Configs; end
  def resque;  Resque; end

end
