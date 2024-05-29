class MoveTitleToLeaves < ActiveRecord::Migration[7.2]
  def change
    add_column :leaves, :title, :string

    execute <<-SQL
      update leaves
      set title = pages.title
      from pages
      where leaves.leafable_type = 'Page'
      and leaves.leafable_id = pages.id;
    SQL

    execute <<-SQL
      update leaves
      set title = pictures.title
      from pictures
      where leaves.leafable_type = 'Picture'
      and leaves.leafable_id = pictures.id;
    SQL

    execute <<-SQL
      update leaves
      set title = sections.title
      from sections
      where leaves.leafable_type = 'Section'
      and leaves.leafable_id = sections.id;
    SQL

    change_column_null :leaves, :title, false

    remove_column :pages, :title
    remove_column :pictures, :title
    remove_column :sections, :title
  end
end
