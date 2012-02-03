module RequestMacros
  def login_any_user
    user = Factory.create(:user)
    user.confirm!
    login(user)
    return user
  end

  def login(user)
    login_as(user, :scope => :user)
  end
  
  def url_for_selenium(options = nil)
    # Make ActionDispatch::Routing::UrlFor do the heavy lifting
    url = url_for(options)
    # Then strip off the bogus domain, because this causes issues
    # with Selenium.
    url.sub!('http://www.example.com', '')
    return url
  end
end
