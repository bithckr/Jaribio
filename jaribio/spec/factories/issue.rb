Factory.define :issue do |s|
  s.name { Forgery(:lorem_ipsum).words(4) }
  s.url { 'http://' + Forgery(:internet).domain }
end
