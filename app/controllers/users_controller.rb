class UsersController < ApplicationController
  before_action :authenticate_user! # Для защиты маршрутов, доступ к которым требует аутентификации
  before_action :owner_or_admin!, except: [:show]

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def update
    if @user.update(current_user.admin? ? user_params : user_params.except(:role))
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :name,  :phone, :password, :role)
  end
end
