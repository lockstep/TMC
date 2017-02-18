class CreateFeedPolicies < ActiveRecord::Migration
  def change
    create_table :feed_policies do |t|
      t.string :type
      t.references :feedable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
