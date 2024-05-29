class LeafablesController < ApplicationController
  include SetBookLeaf

  def new
    @leafable = leafable_class.new
  end

  def create
    @leafable = new_leafable
    @book.leaves.create! leaf_params.merge(leafable: @leafable)

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
    @leaf.edit leafable_params: leafable_params, leaf_params: leaf_params

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
    def new_leafable
      leafable_class.new leafable_params
    end

    def leaf_params
      params.require(:leaf).permit(:title)
    end

    def leafable_class
      raise NotImplementedError.new "Implement in subclass"
    end

    def leafable_params
      raise NotImplementedError.new "Implement in subclass"
    end
end
