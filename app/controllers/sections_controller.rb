class SectionsController < ApplicationController
  include SetBookLeaf

  def new
    @section = Section.new
  end

  def create
    @book.press new_section
    redirect_to @book
  end

  def show
  end

  def edit
  end

  def update
    @section.update! section_params
    redirect_to @book
  end

  def destroy
    @leaf.destroy
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
