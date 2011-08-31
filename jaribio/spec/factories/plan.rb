Factory.define :plan do |s|
  s.association :user
  s.name { Forgery(:lorem_ipsum).words(4) }
end
