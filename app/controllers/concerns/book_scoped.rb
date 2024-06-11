module BookScoped extend ActiveSupport::Concern
  included do
    before_action :set_book
  end

  private
    def set_book
      books = signed_in? ? Current.user.accessable_or_published_books : Book.published
      @book = books.find(params[:book_id])
    end

    def ensure_editable
      head :forbidden unless @book.editable?
    end
end
