# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :step do
    action "MyString"
    results "MyString"
    sort_order 1
  end
end
