redis: (ps aux | grep 6379 | grep redis | awk '{ print $2 }' | xargs kill -s SIGINT) && redis-server
resque: QUEUE=* bundle exec rake resque:work
scheduler: bundle exec rake resque:scheduler
web: rails s -p 3000