module ApplicationHelper
  def ac
    ActiveRecord::Base.connection
  end

  def use(config)
    ActiveRecord::Base.establish_connection config.to_sym
    ac
  end

end

extend ApplicationHelper
