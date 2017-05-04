class CreateExternalConferenceRegistrations < ActiveRecord::Migration
  def change
    create_table :external_conference_registrations do |t|
      t.references :conference, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :external_id
      t.string :country_code
      t.string :email
      t.string :company
      t.date :registered_on

      t.timestamps null: false
    end
  end
end
