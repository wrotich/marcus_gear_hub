class ApplicationController < ActionController::API
  before_action :current_cart

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_cart
    @current_cart ||= Cart.first || Cart.create!
  end
end
