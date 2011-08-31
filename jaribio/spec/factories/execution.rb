Factory.define :execution do |s|
  s.association :user
  s.status_code Status::PASS
end
