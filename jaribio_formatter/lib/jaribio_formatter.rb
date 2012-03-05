%w(rspec_formatter.rb record.rb formatter/version.rb).each do |file|
  require File.expand_path(File.join(File.dirname(__FILE__), 'jaribio', file))
end
