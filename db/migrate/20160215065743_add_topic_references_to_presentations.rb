class AddTopicReferencesToPresentations < ActiveRecord::Migration
  def change
    add_reference :presentations, :topic, index: true, foreign_key: true
  end
end
