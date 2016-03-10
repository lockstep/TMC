describe "presentations/index" do
  fixtures :presentations
  fixtures :topics

  before do
    assign(:topics_nav, Topic.includes(:children).where(parent_id: nil))
    assign(:presentations, Presentation.all.page(1))

    render
  end

  it "display list of presentations" do
    presentations.each do |presentation|
      expect(rendered).to match presentation.name
    end
  end
end
