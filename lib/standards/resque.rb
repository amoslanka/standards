module Standards
  class Resque < Rails::Railtie
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__),'../tasks/resque.rake')].each { |f| load f }
    end
  end
end