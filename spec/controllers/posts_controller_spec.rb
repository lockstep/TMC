require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  fixtures :posts

  let(:hello_tmc)   { posts(:hello_tmc) }

  describe '#show' do
    subject { get :show, id: hello_tmc.slug }

    it { is_expected.to render_template('posts/show') }
  end
end
