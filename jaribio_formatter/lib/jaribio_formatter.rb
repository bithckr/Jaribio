%w(remote_object plan rspec_formatter record formatter/version).each do |file|
  require File.expand_path(File.join(File.dirname(__FILE__), 'jaribio', file))
end
