describe NotifySlackWorker do
  fixtures :charges

  before do
    Sidekiq::Testing.inline!
    @charge = charges(:big_payment)
  end

  it 'sends the correct message to Slack' do
    allow_any_instance_of(Slack::Notifier).to receive(:ping) do |*args|
      # arg[0]: Slack::Notifier instance
      # arg[1]: message text
      # arg[2]: options and attachments
      expect(args[1]).to match(/New order/)
      expect(args[2][:icon_emoji]).to eq ':thug_paul:'
      att = args[2][:attachments][0]
      expect(att[:title]).to include @charge.order_id.to_s
      expect(att[:title_link]).to eq admin_order_url(@charge.order_id)
      order_total = att[:fields][0]
      expect(order_total[:value]).to eq '$8.00'
      monthly_sales = att[:fields][1]
      expect(monthly_sales[:value]).to match /8\.\d0/
      total_sales = att[:fields][2]
      expect(total_sales[:value]).to match /10\.\d0/
    end
    NotifySlackWorker.perform_async(@charge.id)
  end
end
