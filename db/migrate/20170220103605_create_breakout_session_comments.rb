class CreateBreakoutSessionComments < ActiveRecord::Migration
  def change
    create_table :breakout_session_comments do |t|
      t.integer :user_id
      t.integer :breakout_session_id
      t.string  :message

      t.timestamps null: false
    end

    add_index :breakout_session_comments, [:user_id, :breakout_session_id],
      name: 'breakout_session_comments_index'
  end
end
