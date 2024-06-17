class ChangeDraftAndPublishedToActive < ActiveRecord::Migration[8.0]
  def change
    execute "update leaves set status = 'active' where status != 'trashed'"
  end
end
