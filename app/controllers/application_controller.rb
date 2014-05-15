class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :create_guest_if_needed
  
  after_filter :set_csrf_cookie_for_ng
  
  
  def create_guest_if_needed
    session[:user_id] = nil if User.count == 0
    return if session[:user_id] # already logged in, don't need to create another one
    @user = User.new_guest
    @user.save!(validate: false)
    sign_in @user
    session[:user_id] = @user.id
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end
  
  protected

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end
end
