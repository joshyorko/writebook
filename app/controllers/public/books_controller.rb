module Public
  class BooksController < ApplicationController
    def show
      @book = Book.find_by! slug: params[:id]
    end
  end
end
