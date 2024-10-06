class CreatePageSearchIndexTable < ActiveRecord::Migration[8.0]
  def change
    create_virtual_table "page_search_index", "fts5", [ "body", "tokenize='porter'" ]

    Page.sync_search_index
  end
end
