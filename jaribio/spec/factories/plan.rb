Factory.define :plan do |s|
  s.association :user
  s.sequence(:name) { |n| "Plan #{n}" }
end
