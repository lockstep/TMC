describe 'Error pages', type: :feature do
  include_context 'testing production errors'
  context 'record not found' do
    it 'redirects to 404' do
      visit order_path 0
      expect(page).to have_content 'does not exist'
      expect(page).to have_link 'Keep shopping'
    end
    it 'notifies Airbrake' do
      allow(Airbrake).to receive(:notify)
      visit order_path 1
      expect(Airbrake).to have_received(:notify)
    end
  end
  context 'page not found' do
    it 'redirects to 404' do
      visit '/made-up-path'
      expect(page).to have_content 'does not exist'
      expect(page).to have_link 'Keep shopping'
    end
    it 'does not notify Airbrake' do
      allow(Airbrake).to receive(:notify)
      visit '/made-up'
      expect(Airbrake).not_to have_received(:notify)
    end
  end
  context '500' do
    before do
      allow_any_instance_of(OrdersController).to receive(:set_order)
        .and_raise('total crash')
    end
    it 'renders the 500 page' do
      visit order_path 1
      expect(page).to have_content 'highly trained monkeys'
      expect(page).to have_link "Let's go"
    end
    it 'notifies Airbrake' do
      allow(Airbrake).to receive(:notify)
      visit order_path 1
      expect(Airbrake).to have_received(:notify)
    end
  end
end
