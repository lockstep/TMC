describe RecommendedVendorLinkMonitor do
  fixtures :products
  before { @product = products(:tractor) }

  context 'product with good link' do
    before do
      allow(Net::HTTP).to receive(:get)
    end
    it 'does nothing' do
      RecommendedVendorLinkMonitor.new.perform
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end
  end
  context 'product with bad link' do
    before do
      allow(Net::HTTP).to receive(:get).and_raise(SocketError)
    end
    it 'alerts admin via email' do
      RecommendedVendorLinkMonitor.new.perform
      expect(ActionMailer::Base.deliveries.count).to eq 1
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq 'Bad Link Found on TMC'
      expect(email.to_s).to match 'http://tractors.example.com'
    end
  end
  context 'product with bad path' do
    before { allow(Net::HTTP).to receive(:get).and_return("404") }
    it 'alerts admin via email' do
      RecommendedVendorLinkMonitor.new.perform
      expect(ActionMailer::Base.deliveries.count).to eq 1
      email = ActionMailer::Base.deliveries.first
      expect(email.subject).to eq 'Bad Link Found on TMC'
      expect(email.to_s).to match 'http://tractors.example.com'
    end
  end
end
