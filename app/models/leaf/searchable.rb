module Leaf::Searchable
  extend ActiveSupport::Concern

  included do
    after_create_commit  :create_in_search_index,   if: :searchable?
    after_update_commit  :update_in_search_index,   if: :searchable?
    after_destroy_commit :remove_from_search_index, if: :searchable?

    scope :favoring_title, -> { order(Arel.sql("bm25(leaf_search_index, 2.0)")) }
  end

  class_methods do
    def search(terms)
      terms = sanitize_query_syntax(terms)

      if terms.present?
        perform_search(terms)
      else
        none
      end
    end

    def reindex_all
      all.map &:reindex
    end

    private
      def sanitize_query_syntax(terms)
        terms = remove_invalid_search_characters(terms)
        terms = remove_unbalanced_quotes(terms)
        terms
      end

      def perform_search(terms)
        joins("join leaf_search_index on leaves.id = leaf_search_index.rowid")
          .where("leaf_search_index match ?", terms)
          .select(
            "leaves.*",
            "highlight(leaf_search_index, 0, '<mark>', '</mark>') as title_match",
            "snippet(leaf_search_index, 1, '<mark>', '</mark>', '...', 20) as content_match")
      end

      def remove_invalid_search_characters(terms)
        terms.gsub(/[^\w"]/, " ")
      end

      def remove_unbalanced_quotes(terms)
        if terms.count("\"").even?
          terms
        else
          terms.gsub("\"", " ")
        end
      end
  end

  def reindex
    update_in_search_index if searchable?
  end

  private
    def searchable?
      searchable_content
    end

    def create_in_search_index
      execute_sql_with_binds "insert into leaf_search_index(rowid, title, content) values (?, ?, ?)",
        id, title, searchable_content
    end

    def update_in_search_index
      transaction do
        updated = execute_sql_with_binds "update leaf_search_index set title = ?, content = ? where rowid = ?",
          title, searchable_content, id

        create_in_search_index unless updated
      end
    end

    def remove_from_search_index
      execute_sql_with_binds "delete from leaf_search_index where rowid = ?", id
    end

    def execute_sql_with_binds(*statement)
      self.class.connection.execute self.class.sanitize_sql(statement)

      self.class.connection.raw_connection.changes.nonzero?
    end
end
