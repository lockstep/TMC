describe 'breakout session exists', type: :request do
  before do
    @conference = create(:conference)
    @breakout_session_location = create(:breakout_session_location)
    @breakout_session = create(
      :breakout_session,
      location: @breakout_session_location
    )
    @timeslot = create(
      :breakout_session_location_timeslot,
      day: Date.today,
      breakout_session: @breakout_session
    )
    @conference.update(
      breakout_session_locations: [ @breakout_session_location ],
      breakout_sessions: [ @breakout_session ]
    )
  end
  describe 'GET /api/v1/conferences/:id/breakout_sessions' do
    before {
      @user = create(:user)
    }
    it 'should return correct data of breakout session' do
      get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
        auth_headers(@user)
      breakout_session = response_json['breakout_sessions'][0]
      expect(breakout_session['name']).to eq @breakout_session.name
      expect(breakout_session['location_name'])
        .to eq @breakout_session_location.name
      expect(breakout_session['day'])
        .to eq @timeslot.day.strftime('%A %b %e')
      expect(breakout_session['organizers'])
        .to eq []
    end
    context 'a breakout session has many organizers' do
      before do
        @organizer = create(
          :user,
          first_name: 'John',
          last_name: 'Doe'
        )
        @breakout_session.update(organizers: [ @user, @organizer ])
      end
      it 'should return organizers correctly' do
        get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
          auth_headers(@user)
        breakout_session = response_json['breakout_sessions'][0]
        organizers = breakout_session['organizers']
        expect(organizers.size).to eq 2
        expect(organizers[1]['full_name']).to eq 'John Doe'
      end
    end
    context 'another breakout session created' do
      before do
        @breakout_session_location_2 = create(:breakout_session_location)
        @breakout_session_2 = create(
          :breakout_session,
          name: 'painting',
          slug: 'painting',
          location: @breakout_session_location_2
        )
        create(
          :breakout_session_location_timeslot,
          day: Date.today,
          breakout_session: @breakout_session_2
        )
        @conference.update(
          breakout_session_locations: [ 
            @breakout_session_location,
            @breakout_session_location_2
          ],
          breakout_sessions: [
            @breakout_session,
            @breakout_session_2
          ]
        )
      end
      it 'should return a list of breakout sessions correctly' do
        get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
          auth_headers(@user)
        breakout_sessions = response_json['breakout_sessions']
        breakout_session = breakout_sessions[1]
        expect(breakout_sessions.size).to eq 2
        expect(breakout_session['name']).to eq @breakout_session_2.name
      end
      context 'non-approved breakout session exists' do
        before do
          @breakout_session_2.update(approved: false)
        end
        it 'does not return a non-approved breakout session' do
          get "/api/v1/conferences/#{@conference.id}/breakout_sessions",
            auth_headers(@user)
          breakout_sessions = response_json['breakout_sessions']
          expect(breakout_sessions.size).to eq 1
        end
      end
    end
  end

  describe 'GET /api/v1/breakout_sessions' do
    context 'breakout session exists with a hardcoded conference' do
      before do
        allow_any_instance_of(Api::V1::BreakoutSessionsController)
          .to receive(:find_conference_id).and_return(@conference.id)
      end

      it 'should return correct data of breakout session' do
        get "/api/v1/breakout_sessions"
        breakout_session = response_json['breakout_sessions'][0]
        expect(breakout_session['name']).to eq @breakout_session.name
        expect(breakout_session['location_name'])
          .to eq @breakout_session_location.name
        expect(breakout_session['day'])
          .to eq @timeslot.day.strftime('%A %b %e')
        expect(breakout_session['organizers'])
          .to eq []
      end
      context 'a breakout session has many organizers' do
        before do
          @user = create(:user)
          @organizer = create(
            :user,
            first_name: 'John',
            last_name: 'Doe'
          )
          @breakout_session.update(organizers: [ @user, @organizer ])
        end
        it 'should return organizers correctly' do
          get "/api/v1/breakout_sessions"
          breakout_session = response_json['breakout_sessions'][0]
          organizers = breakout_session['organizers']
          expect(organizers.size).to eq 2
          expect(organizers[1]['full_name']).to eq 'John Doe'
        end
      end
      context 'another breakout session created' do
        before do
          @breakout_session_location_2 = create(:breakout_session_location)
          @breakout_session_2 = create(
            :breakout_session,
            name: 'painting',
            slug: 'painting',
            location: @breakout_session_location_2
          )
          create(
            :breakout_session_location_timeslot,
            day: Date.today,
            breakout_session: @breakout_session_2
          )
          @conference.update(
            breakout_session_locations: [
              @breakout_session_location,
              @breakout_session_location_2
            ],
            breakout_sessions: [
              @breakout_session,
              @breakout_session_2
            ]
          )
        end
        it 'should return a list of breakout sessions correctly' do
          get "/api/v1/breakout_sessions"
          breakout_sessions = response_json['breakout_sessions']
          breakout_session = breakout_sessions[1]
          expect(breakout_sessions.size).to eq 2
          expect(breakout_session['name']).to eq @breakout_session_2.name
        end
        context 'non-approved breakout session exists' do
          before { @breakout_session_2.update(approved: false) }

          it 'does not return a non-approved breakout session' do
            get "/api/v1/breakout_sessions"
            breakout_sessions = response_json['breakout_sessions']
            expect(breakout_sessions.size).to eq 1
          end
        end
      end
    end
  end

  describe 'GET /api/v1/breakout_sessions/:id' do
    before {
      @user = create(:user)
    }
    it 'should return the correct data of a single breakout session' do
      get "/api/v1/breakout_sessions/#{@breakout_session.id}",
        auth_headers(@user)
      breakout_session = response_json['breakout_session']
      expect(breakout_session['name']).to eq @breakout_session.name
      expect(breakout_session['location_name'])
        .to eq @breakout_session_location.name
      expect(breakout_session['day'])
        .to eq @timeslot.day.strftime('%A %b %e')
      expect(breakout_session['organizers'])
        .to eq []
    end
    context 'non-approved breakout session exists' do
      before do
        @breakout_session.update(approved: false)
      end
      it 'provides proper error' do
        get "/api/v1/breakout_sessions/#{@breakout_session.id}",
          auth_headers(@user)
        expect(response_json["meta"]["errors"]["message"])
          .to include 'resource not found'
      end
    end
  end

  describe 'POST /api/v1/breakout_sessions/:id/comments' do
    context '@user is authenticated' do
      before { @user = create(:user) }
      context 'user does not belong to directory' do
        before do
          post "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
            comment_params, auth_headers(@user)
        end
        it_behaves_like 'an unsuccessful resource create'
      end
      context 'user belongs to directory' do
        before do
          Sidekiq::Testing.fake!
          @user.update(opted_in_to_public_directory: true)
        end
        it 'executes resize worker when raw image key is present' do
          expect {
            post "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
              image_params, auth_headers(@user)
          }.to change(FeedItemImageResizeWorker.jobs, :size).by(1)
        end
        it 'adds image with message successfully' do
          post "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
            { 
              'feed_item':
              {
                'message': 'a general comment',
                'raw_image_s3_key': 'image-s3-key'
              } 
            }, auth_headers(@user)
          expect(response.status).to eq 201
          expect(@breakout_session.comments.size).to eq 1
        end
        context 'params do not include message and image' do
          it 'provides the proper error' do
            post "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
              { 'feed_item': { message: '' } },
              auth_headers(@user)
            expect(response_json['meta']['errors']['message'][0])
              .to eq "can't be blank"
          end
        end
      end
    end
    context 'unauthenticated user' do
      before do
        post "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
          comment_params
      end
      it_behaves_like 'an unauthorized request'
    end

    def comment_params
      { 
        feed_item:
        {
          message: 'a general comment'
        } 
      }
    end
    def image_params
      { 
        feed_item:
        {
          raw_image_s3_key: 'image-s3-key'
        } 
      }
    end
  end

  describe 'GET /api/v1/breakout_session/:id/comments' do
    context '@user is authenticated' do
      before do
        @user = create(:user)
        create_list(
          :feed_comment,
          3,
          feedable: @breakout_session,
          author: @user
        )
        image_with_comment = create(
          :feed_comment,
          feedable: @breakout_session,
          raw_image_s3_key: 's3-key',
          author: @user
        )
      end
      it 'returns a list of comments belonging to the breakout session' do
        get "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
          auth_headers(@user)
        expect(response_json['comments'].size).to eq 4
      end
      it "returns user's data along with their comment" do
        get "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
          auth_headers(@user)
        comment = response_json['comments'][0]
        expect(comment['author']['full_name']).to eq 'Jane Austen'
        expect(comment['author']['avatar_url_thumb']).not_to eq nil
      end
      context 'lot of comments exist' do
        before do
          create_list(:feed_comment, 15, feedable: @breakout_session)
        end
        it 'only shows 15 comments at a time' do
          get "/api/v1/breakout_sessions/#{@breakout_session.id}/comments",
            auth_headers(@user)
          expect(response_json['comments'].size).to eq 15
          expect(response_json['meta']['current_page']).to eq 1
          expect(response_json['meta']['per_page']).to eq 15
          expect(response_json['meta']['total_pages']).to eq 2
        end
        it 'can get the next page of users' do
          get "/api/v1/breakout_sessions/#{@breakout_session.id}/comments?page=2",
            auth_headers(@user)
          expect(response_json['comments'].size).to eq 4
        end
      end
    end
    context 'unauthenticated user' do
      before do
        get "/api/v1/breakout_sessions/#{@breakout_session.id}/comments"
      end
      it_behaves_like 'an unauthorized request'
    end
  end
end
