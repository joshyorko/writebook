module Page::Searchable
  extend ActiveSupport::Concern

  included do
    after_create_commit  :create_in_search_index
    after_update_commit  :update_in_search_index
    after_destroy_commit :remove_from_search_index

    scope :search,    ->(query) { joins("join page_search_index idx on pages.id = idx.rowid").where("idx.body match ?", query) }
    scope :search_in, ->(query) { search(query).select("pages.*, snippet(page_search_index, 0, '<mark>', '</mark>', '...', 20) as match") }
  end

  class_methods do
    def sync_search_index
      all.map &:sync_search_index
    end
  end

  def sync_search_index
    update_in_search_index
  end

  private
    def create_in_search_index
      execute_sql_with_binds "insert into page_search_index(rowid, body) values (?, ?)", id, body_text
    end

    def update_in_search_index
      updated = execute_sql_with_binds "update page_search_index set body = ? where rowid = ?", body_text, id
      create_in_search_index unless updated
    end

    def remove_from_search_index
      execute_sql_with_binds "delete from page_search_index where rowid = ?", id
    end

    def execute_sql_with_binds(*statement)
      self.class.connection.execute self.class.sanitize_sql(statement)
      self.class.connection.raw_connection.changes > 0
    end
end
