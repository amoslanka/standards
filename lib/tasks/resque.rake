require 'resque/tasks'

namespace :resque do
  task :setup => :environment do
    ENV['QUEUE'] ||= '*'
    Resque.after_fork do |job|
      defined?(ActiveRecord) and ActiveRecord::Base.establish_connection
    end
  end
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"