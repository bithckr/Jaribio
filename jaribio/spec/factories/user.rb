Factory.define :user do |s|
  s.email { Forgery(:internet).email_address }
  s.password { User.send(:generate_token, "encrypted_password").slice(0,6) }
end
