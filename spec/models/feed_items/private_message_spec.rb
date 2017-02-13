describe FeedItems::PrivateMessage do
  describe '::conversation_between' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @message1 = create(:private_message, author: @user1, feedable: @user2)
      @message2 = create(:private_message, author: @user2, feedable: @user1)
    end

    it 'can limit results' do
      messages = FeedItems::PrivateMessage.conversation_between(@user1, @user2)
      expect(messages).to include @message1
      expect(messages).to include @message2
      messages = FeedItems::PrivateMessage
        .conversation_between(@user1, @user2, 1)
      expect(messages).to include @message2
      expect(messages).not_to include @message1
    end
  end
end
