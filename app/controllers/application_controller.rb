class ApplicationController < ActionController::API
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  before_action :current_cart

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_cart
    @current_cart ||= if current_user
      current_user.cart || current_user.create_cart
    else
      session_id = session[:session_id] ||= SecureRandom.hex(16)
      Cart.find_or_create_by(session_id: session_id)
    end
  end

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end

  helper_method :current_user, :current_cart
end
