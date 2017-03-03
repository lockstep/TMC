describe InterestsController, type: :controller do
  fixtures :users
  fixtures :interests

  before do
    @user = users(:michelle)
    @interest = interests(:teaching)
    request.env["HTTP_REFERER"] = root_path
  end

  describe '#add_user_interest' do
    context 'signed in user' do
      before { sign_in @user }
      it 'adds user the interest' do
        post :add_user_interest, id: @interest.id, user_id: @user.id
        expect(@user.reload.interests.include?(@interest)).to eq true
      end
      context 'add interest to other user' do
        it 'does not add the other user the interest' do
          post :add_user_interest, id: @interest.id,
            user_id: users(:paul).id
          expect(@user.reload.interests.include?(@interest)).to eq false
          expect(users(:paul).reload.interests.include?(@interest))
            .to eq false
        end
      end
    end
  end
end
