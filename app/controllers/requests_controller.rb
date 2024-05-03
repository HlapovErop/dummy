class RequestsController < ApplicationController
  before_action :authenticate_user! # Для защиты маршрутов, доступ к которым требует аутентификации
  before_action :set_request, only: [:show, :update, :destroy]

  # GET /requests
  def index
    @requests = current_user.requests
    render json: @requests
  end

  # GET /requests/1
  def show
    render json: @request
  end

  # POST /requests
  def create
    @request = current_user.requests.build(request_params)

    if @request.save
      render json: @request, status: :created
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(current_user.admin? ? request_params : request_params.except(:state))
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def request_params
    params.require(:request).permit(:number, :description, :state)
  end
end
