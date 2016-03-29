require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  fixtures :posts

  let(:hello_tmc)   { posts(:hello_tmc) }

  describe '#index' do
    subject { get :index }

    it { is_expected.to render_template('posts/index') }
  end

  describe '#show' do
    subject { get :show, id: hello_tmc.slug }

    it { is_expected.to render_template('posts/show') }
  end
end
