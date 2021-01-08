module ApplicationHelper
  def dbc
    ActiveRecord::Base.connection
  end
end

extend ApplicationHelper
