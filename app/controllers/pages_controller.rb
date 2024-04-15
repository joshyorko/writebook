class PagesController < ApplicationController
  include SetBookLeaf

  def new
    @page = Page.new
  end

  def create
    @leafable = new_page
    @book.press @leafable

    respond_to do |format|
      format.turbo_stream { render }
      format.html { redirect_to @book }
    end
  end

  def show
  end

  def edit
  end

  def update
    @leaf.edit page_params

    respond_to do |format|
      format.turbo_stream { render }
      format.html { redirect_to leafable_url(@leaf) }
    end
  end

  def destroy
    @leaf.trashed!
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
