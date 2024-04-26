class Pages::UploadsController < ApplicationController
  before_action :set_page

  def create
    @attachment = @page.leaf.attachments.build
    @attachment.file.attach params[:file]
    @attachment.save!
  end

  private
    def set_page
      @book = Book.find(params[:book_id])
      @page = Page.includes(:leaf).where(leaf: { book: @book }).find(params[:page_id])
    end
end
