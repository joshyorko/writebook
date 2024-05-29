module PageScoped extend ActiveSupport::Concern
  included do
    before_action :set_page
  end

  private
    def set_page
      @page = Page.includes(leaf: { book: :accesses })
        .where({ accesses: { user: Current.user } })
        .find(params[:page_id])
    end
end
