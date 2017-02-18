FactoryGirl.define do
  factory :disabled_messages_policy, class: 'FeedPolicies::FeedItemsDisabled' do
    type 'FeedPolicies::FeedItemsDisabled'
    feedable nil
  end
end
