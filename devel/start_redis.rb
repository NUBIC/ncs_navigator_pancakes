#!/usr/bin/env ruby

require 'fileutils'
require 'shellwords'
require 'erb'

include FileUtils

abort "PORT or SCRATCH_DIR not set" unless ENV['PORT'] && ENV['SCRATCH_DIR']

port = ENV['PORT']
scratch_dir = ENV['SCRATCH_DIR']
redis_dir = "#{scratch_dir}/redis.#{port}"

mkdir_p redis_dir

conf_path = "#{redis_dir}/redis.conf"
erb = ERB.new(File.read(File.expand_path('../redis.conf.erb', __FILE__)))

File.open(conf_path, 'w') do |f|
  f.write(erb.result(binding))
end

puts conf_path

exec "redis-server #{Shellwords.shellescape(conf_path)}"
