describe 'user fetching conference data', type: :request do
  before do
    @conference = create(:conference)
    create(:conference, name: 'Monte Congress', slug: 'monte-congress')
  end

  describe 'GET /conferences.json' do
    before { @user = create(:user) }
    it 'should return conferences list' do
      get "/conferences.json", auth_headers(@user)
      conferences = response_json['conferences']
      expect(conferences.size).to eq 2
      expect(conferences.first['name']).to eq 'AMI Congress'
      expect(conferences.last['name']).to eq 'Monte Congress'
    end
  end

  describe 'GET /conferences/:id.json' do
    before { @user = create(:user) }
    it 'should return conference data' do
      get "/conferences/#{@conference.id}.json"
      conference = response_json['conference']
      expect(conference['name']).to eq @conference.name
    end
    it 'should return conference data with slug' do
      get "/conferences/#{@conference.slug}.json"
      conference = response_json['conference']
      expect(conference['name']).to eq @conference.name
    end
  end

  describe 'POST /api/v1/conferences/:id/images' do
    context '@user is authenticated' do
      before { @user = create(:user) }
      context 'user does not belong to directory' do
        before do
          post "/api/v1/conferences/#{@conference.id}/images",
            { "feed_item": { "raw_image_s3_key": "some-key" } },
            auth_headers(@user)
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
            post "/api/v1/conferences/#{@conference.id}/images",
              { "feed_item": { "raw_image_s3_key": "some-key" } },
              auth_headers(@user)
          }.to change(FeedItemImageResizeWorker.jobs, :size).by(1)
        end
      end
    end

    context 'unauthenticated user' do
      before do
        post "/api/v1/conferences/#{@conference.id}/images",
          { "feed_item": { "raw_image_s3_key": "some-key" } }
      end
      it_behaves_like 'an unauthorized request'
    end
  end

  describe 'GET /api/v1/conferences/:id/images' do
    context '@user is authenticated' do
      before do
        @user = create(:user)
        3.times { create(:feed_image, author: @user, feedable: @conference) }
      end
      it 'should return list of conference images' do
        get "/api/v1/conferences/#{@conference.id}/images", auth_headers(@user)
        images = response_json['images']
        expect(images.size).to eq(3)
        expect(images.first['owner']).to eq @user.full_name
      end
    end
  end
end
