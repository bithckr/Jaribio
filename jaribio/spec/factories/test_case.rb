Factory.define :test_case do |s|
  s.sequence(:name) { |n| "Test Case #{n}" }
  s.association :user
  s.text { Forgery(:lorem_ipsum).words(10) }
  s.expectations { Forgery(:lorem_ipsum).words(10) }
end
