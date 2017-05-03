describe FeedItemsController do
  describe '#send_message' do
    before do
      Sidekiq::Testing.inline!
      @user1 = create(:user, opted_in_to_public_directory: true)
      @user2 = create(:user)
      request.env["HTTP_REFERER"] = root_path
    end
    context 'via api', type: :request do
      context 'user authenticated' do
        it 'sends the private message via email' do
          post "/api/v1/users/#{@user2.id}/send_message",
            { feed_item: { message: 'my message' } }, auth_headers(@user1)
          expect(FeedItems::PrivateMessage.count).to eq 1
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          expect(ActionMailer::Base.deliveries.last.encoded)
            .to match 'my message'
        end
      end
      context 'user not authenticated' do
        before do
          post "/api/v1/users/#{@user2.id}/send_message",
            { feed_item: { message: 'my message' } }
        end
        it_behaves_like 'an unauthorized request'
      end
    end
    context 'user signed in', type: :controller do
      before { sign_in @user1 }
      it 'sends the private message via email' do
        post :send_message, {
          user_id: @user2.id,
          feed_item: { message: 'my message' }
        }
        expect(FeedItems::PrivateMessage.count).to eq 1
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.last.encoded)
          .to match 'my message'
      end

      context 'user is not in directory' do
        before { @user1.update(opted_in_to_public_directory: false) }
        it 'redirects them to edit their profile' do
          post :send_message, {
            user_id: @user2.id,
            feed_item: { message: 'my message' }
          }
          expect(response).to redirect_to edit_profile_users_path
        end
      end

      context 'send_breakout_session_comment' do
        before do
          Sidekiq::Testing.inline!
          @organizer = create(:user, email: 'c@t.com')
          @breakout_session = create(
            :breakout_session, organizers: [ @organizer ]
          )
        end
        it 'executes resize worker when raw image key is present' do
          Sidekiq::Testing.fake!
          expect {
            post :send_breakout_session_comment, {
              breakout_session_id: create(:breakout_session).id,
              feed_item: {
                message: 'my message',
                raw_image_s3_key: 'some-key'
              }
            }
          }.to change(FeedItemImageResizeWorker.jobs, :size).by(1)
        end
        it 'sends the comment to the organizer via email' do
          post :send_breakout_session_comment, {
            breakout_session_id: @breakout_session.id,
            feed_item: {
              message: 'my message'
            }
          }
          expect(@breakout_session.comments.count).to eq 1
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          expect(ActionMailer::Base.deliveries.last.encoded)
            .to match 'my message'
          expect(ActionMailer::Base.deliveries.last.to)
            .to eq [ @organizer.email ]
        end
        context 'the author is an organizer' do
          before do
            @breakout_session.update(organizers: [ @user1 ])
          end
          it 'does not send the comment to the organizer via email' do
            post :send_breakout_session_comment, {
              breakout_session_id: @breakout_session.id,
              feed_item: {
                message: 'my message'
              }
            }
            expect(@breakout_session.comments.count).to eq 1
            expect(ActionMailer::Base.deliveries.count).to eq(0)
          end
        end
        it 'does not send images via email' do
          Sidekiq::Testing.fake!
          post :send_breakout_session_comment, {
            breakout_session_id: @breakout_session.id,
            feed_item: {
              raw_image_s3_key: 'my message'
            }
          }
          expect(@breakout_session.comments.count).to eq 1
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      context 'send_interest_comment' do
        before do
          Sidekiq::Testing.fake!
        end
        it 'executes resize worker when raw image key is present' do
          expect {
            post :send_interest_comment, {
              interest_id: create(:interest).id,
              feed_item: {
                message: 'my message',
                raw_image_s3_key: 'some-key'
              }
            }
          }.to change(FeedItemImageResizeWorker.jobs, :size).by(1)
        end
      end
    end
    context 'user is not signed in' do
      it 'redirects' do
        post :send_message, {
          user_id: @user2.id,
          feed_item: { message: 'my message' }
        }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
