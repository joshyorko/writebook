class PagesController < ApplicationController
  include SetBookLeaf

  def new
    @page = Page.new
  end

  def create
    @book.press new_page
    redirect_to @book
  end

  def show
  end

  def edit
  end

  def update
    @page.update! page_params
    redirect_to @book
  end

  def destroy
    @leaf.destroy
    redirect_to @book
  end

  private
    def new_page
      Page.new page_params
    end

    def page_params
      params.require(:page).permit(:title, :body)
    end
end
