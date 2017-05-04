class CreateExternalConferenceRegistrationImports < ActiveRecord::Migration
  def change
    create_table :external_conference_registration_imports do |t|
      t.references :conference, index: true, foreign_key: true
      t.attachment :import_file

      t.timestamps null: false
    end
  end
end
