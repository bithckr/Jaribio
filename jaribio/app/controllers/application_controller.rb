class ApplicationController < ActionController::Base
  protect_from_forgery

  skip_before_filter :verify_authenticity_token, :if => :skip_csrf?

  def skip_csrf?
    # FIXME: make this more specific to avoid completely turning this off
    true
  end
end
