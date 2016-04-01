require 'rails_helper'

RSpec.describe SocialsHelper::ShareButtons, type: :helper do
  let(:test_url)   { 'test_url.com' }
  let(:test_text)  { 'test_text' }

  describe '#pin_it_on_images' do
    subject { helper.pin_it_on_images }

    it { is_expected.to include('//assets.pinterest.com/js/pinit.js') }
  end

  describe '#facebook_like' do
    subject { helper.facebook_like(url: test_url) }

    it { is_expected.to include(test_url) }
  end

  describe '#tweet' do
    subject { helper.tweet(text: test_text, url: test_url) }

    it {  is_expected.to include(test_url)}
    it {  is_expected.to include(test_text)}
  end
end
