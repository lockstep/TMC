describe 'Thank you page', type: :feature do
  fixtures :users
  fixtures :orders
  fixtures :products

  let(:owner)                  { users(:michelle) }
  let(:own_order_paid  )       { orders(:cards_order_completed) }
  let(:purchased_product  )    { products(:animal_cards) }

  context 'signed in user' do
    before do
      signin(owner.email, 'qawsedrf')
      allow_any_instance_of(Product).to receive(:download_url)
        .and_return('my_downloadable_file.pdf')
    end
    it 'renders the success page' do
      visit success_order_path(own_order_paid)
      expect(page).to have_content 'Thank you'
      expect(page).to have_content purchased_product.name
      expect(page).to have_link(
        purchased_product.name, href: /my_downloadable_file/
      )
    end
  end
end
