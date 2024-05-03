# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) } # Предполагаем, что у вас есть фабрика :user
  let(:admin_user) { create(:user, :admin) } # Предполагаем, что у вас есть фабрика :user с административными правами

  describe 'GET #show' do
    it 'returns a success response' do
      sign_in user
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:user_to_update) { create(:user) } # Предполагаем, что у вас есть фабрика :user

    context 'when user is admin' do
      it 'updates the requested user' do
        sign_in admin_user
        patch :update, params: { id: user_to_update.to_param, user: { name: 'Updated Name' } }
        user_to_update.reload
        expect(user_to_update.name).to eq('Updated Name')
      end

      it 'returns a success response' do
        sign_in admin_user
        patch :update, params: { id: user_to_update.to_param, user: { name: 'Updated Name' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not admin' do
      it 'updates the requested user except role' do
        sign_in user
        patch :update, params: { id: user_to_update.to_param, user: { role: 'admin' } }
        user_to_update.reload
        expect(user_to_update.role).not_to eq('admin')
      end

      it 'returns a success response' do
        sign_in user
        patch :update, params: { id: user_to_update.to_param, user: { name: 'Updated Name' } }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_to_destroy) { create(:user) } # Предполагаем, что у вас есть фабрика :user

    it 'destroys the requested user' do
      sign_in user
      expect {
        delete :destroy, params: { id: user_to_destroy.to_param }
      }.to change(User, :count).by(-1)
    end

    it 'returns a success response' do
      sign_in user
      delete :destroy, params: { id: user_to_destroy.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
