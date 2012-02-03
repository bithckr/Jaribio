# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :step do
    action { Forgery(:lorem_ipsum).words(4) }
    results { Forgery(:lorem_ipsum).words(8) }
    sort_order 1
  end
end
