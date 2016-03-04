describe "presentations/show" do
  fixtures :presentations
  fixtures :topics

  let(:quiz_game) { presentations(:quiz_game) }

  before do
    assign(:topics_nav, Topic.includes(:children).where(parent_id: nil))
    assign(:topics, Topic.where(id: quiz_game.topic.related_topic_ids))
    assign(:presentation, Presentation.find(quiz_game.id))

    render
  end

  it 'display presentation\'s name correctly' do
    expect(rendered).to match /#{Regexp.escape(quiz_game.name)}/
  end
end
