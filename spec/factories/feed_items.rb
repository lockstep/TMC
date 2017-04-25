FactoryGirl.define do
  factory :private_message, class: 'FeedItems::PrivateMessage' do
    type 'FeedItems::PrivateMessage'
    message "a private message"
    feedable nil
  end

  factory :feed_image, class: 'FeedItems::Image' do
    type 'FeedItems::Image'
    sequence(:image_file_name) { |n| "abc_#{n}.jpg" }
    image_content_type 'image/jpeg'
    image_file_size 123
    feedable nil
    author nil
    raw_image_s3_key 'some-key'
  end
end
