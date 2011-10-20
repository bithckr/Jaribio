Factory.define :execution do |s|
  s.association :user
  s.status_code Status::PASS
  s.association :test_case
  s.association :plan
end
