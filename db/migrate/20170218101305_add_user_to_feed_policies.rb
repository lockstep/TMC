class AddUserToFeedPolicies < ActiveRecord::Migration
  def change
    add_reference :feed_policies, :user, index: true, foreign_key: true
  end
end
