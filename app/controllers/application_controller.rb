class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  def owner_or_admin!
    @user = User.find(params[:id])

    unless current_user == @user || current_user.admin?
      render json: { error: 'У вас нет прав для выполнения этого действия' }, status: :forbidden
    end
  end
end