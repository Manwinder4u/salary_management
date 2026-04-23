require 'rails_helper'

RSpec.describe 'Employees', type: :request do
  describe 'GET /api/v1/employees' do
    before { create_list(:employee, 3) }

    it 'returns all employees' do
      get '/api/v1/employees'
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].count).to eq(3)
    end
  end

  describe 'GET /api/v1/employees/:id' do
    let(:employee) { create(:employee) }

    it 'returns a single employee' do
      get "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['employee']['id']).to eq(employee.id)
    end

    it 'returns 404 if not found' do
      get '/api/v1/employees/99999'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/employees' do
    let(:employee_params) { attributes_for(:employee) }

    it 'creates a new employee' do
      post '/api/v1/employees', params: { employee: employee_params }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['employee']['id']).to be_present
    end

    it 'returns 422 if invalid' do
      post '/api/v1/employees', params: { employee: { first_name: nil } }
      expect(response).to have_http_status(:unprocessable_content) # unprocessable_entity will be deprecated in Rails 8
      expect(JSON.parse(response.body)['errors']).to be_present
    end
  end

  describe 'PUT /api/v1/employees/:id' do
    let(:employee) { create(:employee) }
    let(:employee_params) { attributes_for(:employee) }

    it 'updates an existing employee' do
      put "/api/v1/employees/#{employee.id}", params: { employee: employee_params }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['employee']['id']).to eq(employee.id)
    end

    it 'returns 422 with invalid params' do
      patch "/api/v1/employees/#{employee.id}", params: { employee: { salary: -1 } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'DELETE /api/v1/employees/:id' do
    let(:employee) { create(:employee) }

    it 'deletes an existing employee' do
      delete "/api/v1/employees/#{employee.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Employee deleted successfully')
    end
  end

  # get employess with pagination
  describe 'GET /api/v1/employees with pagination' do
    before { create_list(:employee, 25) }

    it 'returns paginated results' do
      get '/api/v1/employees', params: { page: 1, per_page: 20 }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)

      puts body
      expect(body['data'].size).to eq(20)
      expect(body['meta']['total_count']).to eq(25)
      expect(body['meta']['current_page']).to eq(1)
      expect(body['meta']['total_pages']).to eq(2)
      expect(body['meta']['per_page']).to eq(20)
    end
  end
end