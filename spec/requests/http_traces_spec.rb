require 'rails_helper'

describe 'reject TRACE requests' do
  include Requests::RequestHelpers

  it 'rejects HTTP TRACE requests' do
    trace root_url

    expect(response).to have_http_status(405)
  end
end
