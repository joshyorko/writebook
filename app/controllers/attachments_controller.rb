class AttachmentsController < ApplicationController
  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end

  def show
    @attachment = Attachment.find_by! slug: "#{params[:id]}.#{params[:ext]}"
    redirect_to @attachment.file.url
  end
end
