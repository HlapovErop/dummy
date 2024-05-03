# spec/controllers/requests_controller_spec.rb
require 'rails_helper'

RSpec.describe RequestsController, type: :controller do
  let(:user) { create(:user) } # Предполагаем, что у вас есть фабрика :user
  let(:admin_user) { create(:user, :admin) } # Предполагаем, что у вас есть фабрика :user с административными правами

  describe 'GET #index' do
    it 'returns a success response' do
      sign_in user
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new request' do
        sign_in user
        expect {
          post :create, params: { request: attributes_for(:request) }
        }.to change(Request, :count).by(1)
      end

      it 'returns a success response' do
        sign_in user
        post :create, params: { request: attributes_for(:request) }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        sign_in user
        post :create, params: { request: { number: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:request) { create(:request) } # Предполагаем, что у вас есть фабрика :request

    context 'when user is admin' do
      it 'updates the requested request' do
        sign_in admin_user
        patch :update, params: { id: request.to_param, request: { state: 'confirmed' } }
        request.reload
        expect(request.state).to eq('confirmed')
      end

      it 'returns a success response' do
        sign_in admin_user
        patch :update, params: { id: request.to_param, request: { state: 'confirmed' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      it 'updates the requested request except state' do
        sign_in user
        patch :update, params: { id: request.to_param, request: { state: 'confirmed' } }
        request.reload
        expect(request.state).not_to eq('confirmed')
      end

      it 'returns a success response' do
        sign_in user
        patch :update, params: { id: request.to_param, request: { state: 'confirmed' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:request) { create(:request) } # Предполагаем, что у вас есть фабрика :request

    it 'destroys the requested request' do
      sign_in user
      expect {
        delete :destroy, params: { id: request.to_param }
      }.to change(Request, :count).by(-1)
    end

    it 'returns a success response' do
      sign_in user
      delete :destroy, params: { id: request.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
