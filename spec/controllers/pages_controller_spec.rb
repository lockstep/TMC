require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe '#show' do
    context 'Access to Homepage' do
      subject { get :show, page: 'home' }
      it { is_expected.to render_template('pages/home')}
    end

    context 'Access non-existing page' do
      subject { get :show, page: 'not-existed' }
      it { is_expected.to redirect_to(root_path) }
    end
  end
end
