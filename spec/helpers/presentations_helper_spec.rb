require 'rails_helper'

RSpec.describe PresentationsHelper, type: :helper do
  fixtures :topics

  let(:topics)        { Topic.includes(:children).where(parent_id: nil) }
  let(:child_topics)  { Topic.where.not(parent_id: nil) }

  describe "#topics_nav" do
    before(:all) do
      assign(:topics_nav, Topic.includes(:children).where(parent_id: nil))
    end

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
    context 'topics are found' do
      before(:all) do
        assign(:topics, Topic.where(id: [Topic.first.id, Topic.last.id]))
      end

      subject { helper.breadcrumb_nav }

      it 'include name in parent topics' do
        is_expected.to include(Topic.first.name)
      end

      it 'include name in child topics' do
        is_expected.to include(Topic.last.name)
      end
    end
    context 'product has no presentation' do
      before do
        assign(:topics, nil)
      end

      subject { helper.breadcrumb_nav }

      it 'does not return breadcrumbs' do
        is_expected.to be_nil
      end
    end
  end
end
