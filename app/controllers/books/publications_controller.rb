class Books::PublicationsController < ApplicationController
  include BookScoped

  def show
  end

  def edit
  end

  def update
    @book.update! book_params
    redirect_to book_publication_path(@book)
  end

  private
    def book_params
      params.require(:book).permit(:published, :slug)
    end
end
