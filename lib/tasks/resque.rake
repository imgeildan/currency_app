require 'resque/tasks'
# require 'resque_scheduler/tasks'
require 'resque/scheduler/tasks'

task "resque:setup" => :environment do
  
Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
  ENV['QUEUES'] = 'default,sleep,wake_up,run'
end

namespace :resque do
  task :setup do
    require 'resque'
    # require 'resque_scheduler'
    # require 'resque/scheduler'

    ENV['QUEUE'] = '*'

    Resque.redis = 'localhost:6379' unless Rails.env == 'production'
    Resque.schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'
  end

  task :scheduler => :setup_schedule
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection } #this is necessary for production environments, otherwise your background jobs will start to fail when hit from many different connections.

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"