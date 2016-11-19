class FakeUspsServer < Sinatra::Base
  get '/ShippingAPI.dll' do
    xml_response 200, 'shipping_rate.xml'
  end

  private

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(
      File.dirname(__FILE__) + '/fake_responses/usps/' + file_name, 'rb'
    ).read
  end
end
