class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :exception

  private

    def authorize
      if request.format.html?
        unless User.find_by(id: session[:user_id])
          redirect_to login_url,
            notice: "Please log in" unless no_admin_in_development
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by(name: username)
          user.try(:authenticate, password)
        end unless request.format.html?
      end
    end

    def no_admin_in_development
      Rails.env.development? && User.count.zero?
    end
end
