class AddAttachmentFileToDownloadables < ActiveRecord::Migration
  def self.up
    change_table :downloadables do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :downloadables, :file
  end
end
