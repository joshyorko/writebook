class CreateAttachments < ActiveRecord::Migration[7.2]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, null: false
      t.string :slug, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
