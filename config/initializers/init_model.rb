# frozen_string_literal: true
if true & ENV['GM']
  db = ActiveRecord::Base.configurations[Rails.env]
  cmd = "rmre -a mysql2 -d #{db['database']} -o app/models -u #{db['username']} -p #{db['password']}"
  p system(cmd)
end


