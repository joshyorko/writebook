class SectionsController < LeafablesController
  private
    def new_leafable
      Section.new
    end

    def leafable_params
      params.fetch(:section, {}).permit(:body, :theme)
    end
end
