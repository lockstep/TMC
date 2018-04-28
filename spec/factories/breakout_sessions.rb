FactoryBot.define do
  factory :breakout_session do
    sequence(:name) { |n| "Teaching #{n}" }
    sequence(:slug) { |n| "teaching-#{n}" }
    description 'test desc'
    approved true
  end
end
