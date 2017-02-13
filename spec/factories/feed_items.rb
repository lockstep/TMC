FactoryGirl.define do
  factory :private_message, class: 'FeedItems::PrivateMessage' do
    type 'FeedItems::PrivateMessage'
    message "a private message"
    feedable nil
  end
end
