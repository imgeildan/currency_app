require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'
# Resque.schedule = YAML.load_file('config/resque_schedule.yml')
Resque.schedule = YAML.load_file('config/resque_schedule.yml')
# Resque.schedule = YAML.load_file(Rails.root.join('config', 'resque_schedule.yml'))

# configure redis connection
#Resque.redis = config[Rails.env]

# configure the schedule
#Resque.schedule = schedule

# set a custom namespace for redis (optional)
#Resque.redis.namespace = "resque:currency_app"

if Rails.env.development?
	Resque.redis = Redis.new(:host => 'localhost', :port => '6379')
    # Resque.redis = Redis.new(:host => 'localhost', :port => 6379)
else
	uri = URI.parse(ENV['REDISTOGO_URL'])  
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

	Resque.redis = REDIS
end