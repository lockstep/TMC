require 'rails_helper'

RSpec.describe SocialsHelper::MetaTags, type: :helper do
  let(:title)     { 'test_title' }
  let(:image_url) { 'test_image_url.jpg' }

  describe '#meta_tags' do
    context 'with only title' do
      subject { helper.meta_tags(title: title) }

      it { is_expected.to include(title) }
    end

    context 'with title and image' do
      subject { helper.meta_tags(title: title, image: image_url) }

      it { is_expected.to include(title) }
      it { is_expected.to include(image_url) }
    end
  end
end
