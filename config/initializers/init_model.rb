
MODELS_DIR = 'app/models'.freeze

if ENV['GM']
  db = ActiveRecord::Base.configurations[Rails.env]
  cmd = "rmre -a mysql2 -d #{db['database']} -o #{MODELS_DIR} -u #{db['username']} -p #{db['password']}"
  p system(cmd)
end
Dir.glob("#{MODELS_DIR}/*.rb").each do |x|
  require File.basename(x)
end