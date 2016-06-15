class RemoveSummaryFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :summary, :text
  end
end
