class SetBookNullsAndUniqueness < ActiveRecord::Migration[8.0]
  def change
    remove_index :books, :slug, if_exists: true
    execute "update books set slug = 'book' where slug is null"

    change_column_null :books, :title, false
    change_column_null :books, :slug, false
  end
end
