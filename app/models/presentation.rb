class Presentation < ActiveRecord::Base
  belongs_to :topic

  searchkick text_middle: [:name]

  def search_data
    {
      name: name,
    }
  end
end
