
db = ActiveRecord::Base.configurations[Rails.env]

if db['auto']
  cmd = "rmre -a mysql2 -d #{db['database']} -o app/models -u #{db['username']} -p #{db['password']}"
  p system(cmd)
end


