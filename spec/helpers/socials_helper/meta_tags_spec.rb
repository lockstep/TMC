require 'rails_helper'

RSpec.describe SocialsHelper::MetaTags, type: :helper do
  fixtures :products
  fixtures :images

  let(:number_cards)    { products(:number_cards) }
  let(:number_board)    { products(:number_board) }

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

  describe '#object_image' do
    context 'object has image(s)' do
      subject { helper.object_image(number_cards) }

      it { is_expected.to eq(number_cards.primary_image.image.url) }
    end

    context 'object doesn\'t have image(s)' do
      subject { helper.object_image(number_board) }

      it { is_expected.to eq SocialsHelper::DEFAULT_IMAGE }
    end
  end
end
