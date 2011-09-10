Factory.define :test_case do |s|
  s.name { Forgery(:lorem_ipsum).words(4) }
  s.association :user
  s.text { Forgery(:lorem_ipsum).words(10) }
  s.expectations { Forgery(:lorem_ipsum).words(10) }
end
