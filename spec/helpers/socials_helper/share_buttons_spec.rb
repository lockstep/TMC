require 'rails_helper'

RSpec.describe SocialsHelper::ShareButtons, type: :helper do
  describe "#pin_it_on_images" do
    subject { helper.pin_it_on_images }

    it { is_expected.to include('//assets.pinterest.com/js/pinit.js') }
  end

  describe "#facebook_like" do
    let(:test_url)  { 'test_url.com' }

    subject { helper.facebook_like(url: test_url) }

    it { is_expected.to include(test_url) }
  end
end
