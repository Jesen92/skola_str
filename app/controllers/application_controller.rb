class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_current_user

  def authenticate_active_admin_user!
   authenticate_user!
   unless current_user.role?(:admin)
      flash[:alert] = "You are not authorized to access this resource!"
      redirect_to root_path
   end
end

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to login_path, :notice => 'Please Login'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

    def set_current_user
      User.current = current_user
    end

  def user_for_paper_trail
    user_signed_in? ? current_user.try(:id) : 'Unknown user'
  end

end