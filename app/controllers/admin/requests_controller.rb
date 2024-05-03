class Admin::RequestsController < ApplicationController
  before_action :authenticate_admin! # Для защиты маршрутов, доступ к которым требует аутентификации

  def index
    @requests = ::Request.all
  end

  private

  def authenticate_admin!
    @token = params[:authorization] || request.headers['Authorization']
    if @token
      jwt_payload = JWT.decode(@token.split(' ').last, 'a2b810d2013133b9e681e78901977f98404c987db1c5e1699e0e86eb63a2467f0c08e4906ab4d5fe9564645699779adcfb23ed4bd847d05b7b7690ac3fa6ebd0').first
      @current_user = User.find(jwt_payload['sub'].to_i)
    end

    if @current_user.blank? || !@current_user.admin?
      render json: { error: 'У вас нет прав для выполнения этого действия', t: @current_user, k: jwt_payload }, status: :forbidden
    end
  end
end
