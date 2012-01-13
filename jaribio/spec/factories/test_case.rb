Factory.define :test_case do |s|
  s.sequence(:name) { |n| "Test Case #{n}" }
  s.association :user
end
