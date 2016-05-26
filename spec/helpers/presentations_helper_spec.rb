describe PresentationsHelper, type: :helper do
  fixtures :topics
  fixtures :products

  let(:topics)        { Topic.includes(:children).where(parent_id: nil) }
  let(:child_topics)  { Topic.where.not(parent_id: nil) }

  describe "#topics_nav" do
    subject { helper.topics_nav }

    it 'include all names in parent topics' do
      topics.pluck(:name).each do |topic_name|
        is_expected.to include(topic_name)
      end
    end

    it 'include all names in child topics' do
      child_topics.pluck(:name).each do |topic_name|
        is_expected.to include(topic_name)
      end
    end
  end

  describe "#breadcrumb_nav" do
    context 'no product given' do
      subject { helper.breadcrumb_nav }
      it 'does not break' do
        is_expected.to be_nil
      end
    end

    context 'topics are found' do
      before do
        @product = products(:ostrich)
      end

      subject { helper.breadcrumb_nav(product: @product) }

      it 'includes parent topic name' do
        is_expected.to include @product.topic.name
      end
    end

    context 'product has no topic' do
      before do
        @flamingo = products(:flamingo)
      end

      subject { helper.breadcrumb_nav(product: @flamingo) }

      it 'does not return breadcrumbs' do
        is_expected.to be_nil
      end
    end
  end
end
