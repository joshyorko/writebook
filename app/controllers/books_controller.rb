class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update ]

  def index
    @books = Book.ordered
  end

  def new
    @book = Book.new
  end

  def create
    book = Book.create! book_params
    redirect_to book
  end

  def show
    @leaves = @book.leaves.excluding_trashed.with_leafables.positioned
  end

  def edit
  end

  def update
    @book.update(book_params)
    redirect_to @book
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :cover)
    end
end
