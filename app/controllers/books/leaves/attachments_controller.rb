class Books::Leaves::AttachmentsController < ApplicationController
  include BookScoped

  before_action :set_leaf

  def create
    @attachment = @leaf.attachments.build
    @attachment.file.attach params[:file]
    @attachment.save!
  end

  private
    def set_leaf
      @leaf = @book.leaves.find params[:leaf_id]
    end
end
