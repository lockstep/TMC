require 'rails_helper'

RSpec.describe PresentationsHelper, type: :helper do
  fixtures :topics

  let(:topics)        { Topic.includes(:children).where(parent_id: nil) }
  let(:child_topics)  { Topic.where.not(parent_id: nil) }

  before(:all) do
    assign(:topics, Topic.includes(:children).where(parent_id: nil))
  end

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
end
