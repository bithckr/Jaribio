Factory.define :case do |s|
  s.association :user
  s.text { Forgery(:lorem_ipsum).words(10) }
  s.expectations { Forgery(:lorem_ipsum).words(10) }
end
