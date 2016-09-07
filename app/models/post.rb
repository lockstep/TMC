class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :title,
    ]
  end

  def stripped_body
    doc = Nokogiri::XML(body)
    doc.xpath("//figcaption").remove
    helpers.strip_tags(doc.text)
  end

  private

  def helpers
    ActionController::Base.helpers
  end
end
