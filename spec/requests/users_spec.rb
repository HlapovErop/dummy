# spec/integration/users_spec.rb
require 'swagger_helper'

describe 'Users API' do
  path '/api/v1/users/{id}' do
    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'user found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 username: { type: :string },
                 email: { type: :string },
                 name: { type: :string },
                 phone: { type: :string },
                 role: { type: :string }
               },
               required: [ 'id', 'username', 'email', 'name', 'phone', 'role' ]

        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    put 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          email: { type: :string },
          name: { type: :string },
          phone: { type: :string },
          password: { type: :string },
          role: { type: :string }
        },
        required: [ 'username', 'email', 'name', 'phone', 'password', 'role' ]
      }

      response '200', 'user updated' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:user) { { username: 'new_username', email: 'new_email@example.com', name: 'New Name', phone: '123456789', password: 'new_password', role: 'admin' } }
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:user) { { username: 'new_username', email: 'new_email@example.com' } } # Неполные данные

        run_test!
      end

      response '403', 'forbidden' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:user) { { username: 'new_username', email: 'new_email@example.com', name: 'New Name', phone: '123456789', password: 'new_password', role: 'admin' } } # Попытка обновления без админских прав

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '204', 'user deleted' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки

        run_test!
      end
    end
  end
end
