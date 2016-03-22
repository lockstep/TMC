shared_examples 'sending_email' do
  it 'already sent' do
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  it 'have correct recipients' do
    expect(ActionMailer::Base.deliveries.first.to).to eq(recipients)
  end

  it 'have correct sender' do
    expect(ActionMailer::Base.deliveries.first.from).to eq(sender)
  end

  it 'have correct subject' do
    expect(ActionMailer::Base.deliveries.first.subject).to eq(subject)
  end
end
