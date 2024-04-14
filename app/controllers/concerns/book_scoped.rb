module BookScoped extend ActiveSupport::Concern
  included do
    before_action :set_book
  end

  private
    def set_book
      @book = Book.find(params[:book_id])
    end
end
