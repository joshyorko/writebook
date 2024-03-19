class PicturesController < ApplicationController
  include SetBookLeaf

  def new
    @picture = Picture.new
  end

  def create
    @book.press new_picture
    redirect_to @book
  end

  def show
  end

  def edit
  end

  def update
    @picture.update! picture_params
    redirect_to @book
  end

  def destroy
    @leaf.destroy
    redirect_to @book
  end

  private
    def picture_params
      Picture.new picture_params
    end

    def picture_params
      params.require(:picture).permit(:title, :image)
    end
end
