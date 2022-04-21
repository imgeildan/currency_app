#require 'resque'
require 'resque/server'

Resque.schedule = YAML.load_file Rails.root.join('config', 'resque_schedule.yml')

if Rails.env.development?
	Resque.redis = Redis.new(:host => 'localhost', :port => '6379')
else
	uri = URI.parse(ENV['REDISTOGO_URL'])  
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
	
	Resque.redis = REDIS
end