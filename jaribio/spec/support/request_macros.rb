module RequestMacros
  def login_any_user
    user = Factory.create(:user)
    user.confirm!
    login(user)
    return user
  end

  def login(user)
    page.driver.post user_session_path, 
      :user => {:email => user.email, :password => user.password}
  end
end
