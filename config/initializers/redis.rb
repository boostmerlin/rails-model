# frozen_string_literal: true

return unless File.exist?('config/redis.yml')

config = Rails.application.config_for(:redis).symbolize_keys!

puts 'init redis...'

$redis = Redis.new(config)

alias $r $redis