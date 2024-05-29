class PagesController < LeafablesController
  before_action :forget_reading_progress, except: :show

  private
    def forget_reading_progress
      cookies.delete "reading_progress_#{@book.id}"
    end

    def leafable_class
      Page
    end

    def leafable_params
      params.require(:page).permit(:body)
    end
end
