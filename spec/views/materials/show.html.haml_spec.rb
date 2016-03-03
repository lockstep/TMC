require "rails_helper"

RSpec.describe "products/show" do
  fixtures :products

  let(:number_cards) { products(:number_cards) }

  before do
    assign(:product, Product.find(number_cards.id))

    render
  end

  it 'display product\'s name correctly' do
    expect(rendered).to match /#{Regexp.escape(number_cards.name)}/
  end
end
