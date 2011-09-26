Factory.define :suite do |s|
  s.association :user
  s.sequence(:name) { |n| "Suite #{n}" }
end
