describe ApplicationController do
  controller do
    def index
      raise NoMethodError
    end
  end

  describe 'handling standard exceptions' do
    it 'redirects to the error 500 page' do
      get :index
      expect(response).to redirect_to error_500_path
    end
    it 'notifies Airbrake' do
      allow(Airbrake).to receive(:notify)
      get :index
      expect(Airbrake).to have_received(:notify)
    end
  end
end
