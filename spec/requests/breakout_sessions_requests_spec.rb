describe 'retrieving breakout sessions for conference', type: :request do
  describe '/api/v1/conferences/:id/breakout_sessions' do
    context 'breakout session exists' do
      before do
        @conference = create(:conference)
        @breakout_session = create(
          :breakout_session, conference: @conference
        )
      end

      context '@user is authenticated' do
        before {
          @user = create(:user)
        }
        it 'should return a list of breakout sessions' do
          get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
            auth_headers(@user)
          breakout_session = response_json['breakout_sessions'][0]
          expect(breakout_session['name']).to eq @breakout_session.name
        end
      end

      context 'unauthenticated user' do
        before do
          get "/api/v1/conferences/#{@conference.id}/breakout_sessions"
        end
        it_behaves_like 'an unauthorized request'
      end
    end

  end
end
