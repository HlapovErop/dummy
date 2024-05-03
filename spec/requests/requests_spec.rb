# spec/integration/requests_spec.rb
require 'swagger_helper'

describe 'Requests API' do
  path '/api/v1/requests' do
    get 'Retrieves all requests' do
      tags 'Requests'
      produces 'application/json'
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'requests found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   number: { type: :string },
                   description: { type: :string },
                   state: { type: :string }
                 },
                 required: [ 'id', 'number', 'description', 'state' ]
               }

        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let!(:requests) { create_list(:request, 5, user: user) }
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }

        run_test!
      end
    end

    post 'Creates a request' do
      tags 'Requests'
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          number: { type: :string },
          description: { type: :string },
          state: { type: :string }
        },
        required: [ 'number', 'description', 'state' ]
      }
      parameter name: :Authorization, in: :header, type: :string

      response '201', 'request created' do
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:request) { { number: '123', description: 'Test request', state: 'pending' } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:request) { { number: '123', description: 'Test request' } } # Неполные данные

        run_test!
      end
    end
  end

  path '/api/v1/requests/{id}' do
    get 'Retrieves a request' do
      tags 'Requests'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'request found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 number: { type: :string },
                 description: { type: :string },
                 state: { type: :string }
               },
               required: [ 'id', 'number', 'description', 'state' ]

        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:id) { create(:request, user: user).id }

        run_test!
      end

      response '404', 'request not found' do
        let(:id) { 'invalid' }
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }

        run_test!
      end
    end

    put 'Updates a request' do
      tags 'Requests'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :request, in: :body, schema: {
        type: :object,
        properties: {
          number: { type: :string },
          description: { type: :string },
          state: { type: :string }
        },
        required: [ 'number', 'description', 'state' ]
      }
      parameter name: :Authorization, in: :header, type: :string

      response '200', 'request updated' do
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:request) { create(:request, user: user) }
        let(:id) { request.id }
        let(:request) { { number: '456', description: 'Updated request', state: 'approved' } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:request) { create(:request, user: user) }
        let(:id) { request.id }
        let(:request) { { number: '456', description: 'Updated request' } } # Неполные данные

        run_test!
      end
    end

    delete 'Deletes a request' do
      tags 'Requests'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :Authorization, in: :header, type: :string

      response '204', 'request deleted' do
        let(:Authorization) { "Bearer #{token}" } # Добавляем токен в заголовки
        let(:token) { JWT.encode({ sub: user.id }, 'secret') }
        let(:user) { create(:user) }
        let(:id) { create(:request, user: user).id }

        run_test!
      end
    end
  end
end
