feature 'Bambini pilot registration' do
  fixtures :users
  fixtures :orders
  fixtures :products
  fixtures :line_items

  let(:user)          { users(:michelle) }
  let(:cards_order)   { orders(:cards_order) }
  let(:number_cards)  { products(:number_cards) }
  let(:number_board)  { products(:number_board) }
  context 'all info provided' do
    xscenario 'user registers successfully' do
      visit root_path
      click_link 'Bambini Pilot'
    end
  end
  context 'missing values' do
    xscenario 'user needs to add all values then may register' do

    end
  end
end
