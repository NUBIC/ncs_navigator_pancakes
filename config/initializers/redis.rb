require 'redis'
require 'redis/namespace'

# There are two Redis connection sources in Pancakes:
#
# 1. Sidekiq's Redis connection pool
# 2. Ours
#
# redis-rb is thread-safe, so we can get away with just using a single Redis
# connection for now.  If it becomes a bottleneck we'll pool it.

if Pancakes::Application.config.services[:redis]
  redis = Redis.new(:url => Pancakes::Application.config.services[:redis][:url])
  ns = Pancakes::Application.config.services[:redis][:namespace]

  $REDIS = Redis::Namespace.new(ns, :redis => redis)
else
  Rails.logger.warn "Redis configuration not found; not connecting"
end
