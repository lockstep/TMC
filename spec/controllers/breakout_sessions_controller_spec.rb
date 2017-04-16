describe BreakoutSessionsController do
  describe '#create' do
    before do
      @conference = create(:conference)
      # @breakout_session = create(:breakout_session)
      @breakout_session_location = create(:breakout_session_location)
      @timeslot = create(:breakout_session_location_timeslot,
                        breakout_session_location: @breakout_session_location)
      @user = create(:user, first_name: 'Paul')
      @user.update(opted_in_to_public_directory: true)
    end
    context 'user signed in' do
      before { sign_in @user }
      it 'associates the organizer' do
        post :create, breakout_session_params
        @breakout_session = BreakoutSession.last
        expect(@breakout_session.organizers).to include @user
      end
      it 'sends an email' do
        Sidekiq::Testing.inline!
        post :create, breakout_session_params
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.encoded)
          .to match 'test'
      end
      it 'associates the timeslot' do
        post :create, breakout_session_params
        @breakout_session = BreakoutSession.last
        expect(@timeslot.reload.breakout_session_id).to eq @breakout_session.id
      end
    end
    context 'user not signed in' do
      it 'sends 401' do
        post :create, breakout_session_params
        expect(response.status).to eq 302
      end
    end
  end

  def breakout_session_params(overrides={})
    {
      id: @conference.slug,
      breakout_session: {
        name: 'test',
        description: 'test',
        breakout_session_location_timeslot: @timeslot.id
      }
    }
  end
end
