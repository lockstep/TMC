class AddSummaryToPresentations < ActiveRecord::Migration
  def change
    add_column :presentations, :summary, :string
  end
end
