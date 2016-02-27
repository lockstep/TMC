require "rails_helper"

RSpec.describe "materials/show" do
  fixtures :materials

  let(:number_cards) { materials(:number_cards) }

  before do
    assign(:material, Material.find(number_cards.id))

    render
  end

  it 'display material\'s name correctly' do
    expect(rendered).to match /#{Regexp.escape(number_cards.name)}/
  end
end
