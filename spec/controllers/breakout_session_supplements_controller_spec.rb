describe BreakoutSessionSupplementsController, type: :controller do
  before do
    @user = create(:user)
    @breakout_session = create(:breakout_session)
    sign_in @user
  end
  describe '#create' do
    context 'user is not the organizer' do
      it 'raises error' do
        expect { post(:create, breakout_session_id: @breakout_session.id) }
          .to raise_error 'Unauthorized'
      end
    end
  end
  describe '#destroy' do
    before do
      @breakout_session_supplement = create(
        :breakout_session_supplement, breakout_session: @breakout_session
      )
    end
    context 'user is not the organizer' do
      it 'raises error' do
        expect { delete(:destroy, id: @breakout_session_supplement.id) }
          .to raise_error 'Unauthorized'
      end
    end
  end
end
