redis_host = Rails.application.secrets.redis && Rails.application.secrets.redis['host'] || 'localhost'
redis_port = Rails.application.secrets.redis && Rails.application.secrets.redis['port'] || 6379

# The constant below will represent ONE connection, present globally in models, controllers, views etc for the instance. No need to do Redis.new everytime
REDIS = Redis.new(host: redis_host, port: redis_port.to_i)
# Redis.current = Redis.new(url:  ENV['REDIS_URL'],
#                           port: ENV['REDIS_PORT'],
#                           db:   ENV['REDIS_DB'])
class DataCache
	def self.data
		@data ||= Redis.new(host: 'localhost', port: 6379)
	end

	def self.set(key, value)
		data.set(key, value)
	end

	def self.get(key)
		data.get(key)
	end

	def self.get_i(key)
		data.get(key).to_i
	end

	def self.del(key)
		data.del(key)
	end
end