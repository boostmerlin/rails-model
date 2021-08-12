
config = Rails.application.config_for(:redis).symbolize_keys!

puts 'init redis...'

$redis = Redis.new(config)