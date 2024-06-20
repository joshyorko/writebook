class ApplicationController < ActionController::Base
  include Authentication, Authorization, VersionHeaders

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def slugged_param(name)
    params[name].to_s.split("-").last
  end
end
