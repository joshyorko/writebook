class Books::Leaves::AttachmentsController < ApplicationController
  include BookScoped

  before_action :set_leaf

  def create
    @attachment = @leaf.attachments.create! attachable: @leaf, file: params[:file]
  end

  private
    def set_leaf
      @leaf = @book.leaves.find params[:leaf_id]
    end
end
