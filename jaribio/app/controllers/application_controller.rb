class ApplicationController < ActionController::Base
  protect_from_forgery

  skip_before_filter :verify_authenticity_token, :if => :skip_csrf?

  def skip_csrf?
    if (user_signed_in?() && current_user.token_authenticated?)
      return true
    end
    false
  end
end
