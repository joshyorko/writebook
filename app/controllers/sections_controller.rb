class SectionsController < ApplicationController
  include SetBookLeaf

  def new
    @section = Section.new
  end

  def create
    @leafable = new_section
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
    @leaf.edit section_params

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
    def new_section
      Section.new section_params
    end

    def section_params
      params.require(:section).permit(:title)
    end
end
