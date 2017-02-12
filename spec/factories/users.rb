FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    first_name 'Jane'
    last_name 'Austen'
    address_country 'CA'
    position User::POSITIONS.first
  end
end
