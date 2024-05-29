class Pages::EditsController < ApplicationController
  include PageScoped

  before_action :set_edit

  private
    def set_edit
      @edit = @page.leaf.edits.find(params[:id])
    end
end
