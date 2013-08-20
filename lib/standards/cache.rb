module Standards
  class Cache < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../tasks/cache.rake')].each { |f| load f }
    end
  end
end