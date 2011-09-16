# Based on comments on this page, to support Selenium without an additional
# gem to clean the database
#
# http://opinionated-programmer.com/2011/02/capybara-and-selenium-with-rspec-and-rails-3/
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    # Thread.current.object_id
    Thread.main.object_id
  end
end
