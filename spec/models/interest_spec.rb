describe Interest, type: :model do
  fixtures :users
  fixtures :interests

  describe 'validations' do
    context 'public name' do
      it 'does not create duplicate public name' do
        interest = Interest.create(name: interests(:peace).name,
                                   public: true)
        expect(interest.valid?).to eq false
        expect(interest.errors.full_messages.first)
          .to match 'Name has already been taken'
      end
    end
  end

  describe 'manage interests' do
    context 'has public interests' do
      before do
        @user = users(:default)
      end
      it 'updates user with new interset' do
        Interest.manage_user_interests(@user, ['Peace'])
        expect(@user.reload.interests.find_by(name: 'Peace')).not_to eq nil
      end
      context 'user has a public interest' do
        before do
          interest = interests(:peace)
          @interest_count = Interest.all.count
          @user.update(interests: [interest])
        end
        it 'creates user private interest' do
          Interest.manage_user_interests(@user, ['Custom'])
          interest_names = @user.reload.interests.pluck(:name)
          expect(interest_names.include?('Custom')).to eq true
          expect(Interest.find_by(name: 'Peace')).not_to eq nil
          expect(Interest.all.count).to eq @interest_count + 1
        end
      end
      context 'user has public and private interests' do
        before do
          interest_1 = interests(:peace)
          interest_2 = interests(:private)
          @interest_count = Interest.all.count
          @user.update(interests: [interest_1, interest_2])
        end
        it 'deletes unused user interest' do
          Interest.manage_user_interests(@user, ['Custom'])
          interest_names = @user.reload.interests.pluck(:name)
          expect(interest_names.include?('Custom')).to eq true
          expect(interest_names.length).to eq 1
          expect(Interest.find_by(name: 'Private')).to eq nil
        end
      end
      context 'update with same interest name' do
        before do
          @user.update(interests: [interests(:peace), interests(:private)])
        end
        it 'does not create duplicate interest' do
          Interest.manage_user_interests(
            @user, ['Peace', 'Private', 'Custom'])
          expect(Interest.where(name: 'Peace').count).to eq 1
          expect(Interest.where(name: 'Private').count).to eq 1
          expect(Interest.where(name: 'Custom').count).to eq 1
        end
      end
    end
  end
end
