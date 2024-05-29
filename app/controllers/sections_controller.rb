class SectionsController < LeafablesController
  private
    def new_leafable
      Section.new
    end

    def leafable_params
      {}
    end
end
