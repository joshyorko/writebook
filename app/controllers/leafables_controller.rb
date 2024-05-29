class LeafablesController < ApplicationController
  include SetBookLeaf

  def new
    @leafable = new_leafable
  end

  def create
    @leafable = new_leafable
    @leaf = @book.leaves.create! leaf_params.merge(leafable: @leafable)

    position_new_leaf @leaf

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
    def leaf_params
      default_leaf_params.merge params.fetch(:leaf, {}).permit(:title)
    end

    def default_leaf_params
      { title: new_leafable.model_name.human }
    end

    def new_leafable
      raise NotImplementedError.new "Implement in subclass"
    end

    def leafable_params
      raise NotImplementedError.new "Implement in subclass"
    end

    def position_new_leaf(leaf)
      if position = params[:position]&.to_i
        leaf.move_to_position position
      end
    end
end
