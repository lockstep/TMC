class RemoveSummaryFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :summary
  end
end
