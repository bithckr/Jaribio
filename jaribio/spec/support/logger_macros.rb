module LoggerMacros
  def enable_logger
    @orig_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  def disable_logger
    ActiveRecord::Base.logger = @orig_logger
  end
end
