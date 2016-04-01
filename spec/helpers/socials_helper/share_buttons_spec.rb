require 'rails_helper'

RSpec.describe SocialsHelper::ShareButtons, type: :helper do
  let(:test_url)     { 'test_url.com' }
  let(:test_image)   { 'test_image.jpg' }
  let(:test_text)    { 'test_text' }

  describe '#pin_it' do
    subject { helper.pin_it(url: test_url,
                            image: test_image,
                            description: test_text)
            }

    it { is_expected.to include(test_url) }
    it { is_expected.to include(test_image) }
    it { is_expected.to include(test_text) }
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
