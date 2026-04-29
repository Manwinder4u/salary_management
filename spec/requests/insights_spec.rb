require 'rails_helper'

RSpec.describe 'Insights API', type: :request do
  before do
    create(:employee, country: 'India', job_title: 'Software Engineer', department: 'Engineering', salary: 100_000)
    create(:employee, country: 'India', job_title: 'Software Engineer', department: 'Engineering', salary: 200_000)
    create(:employee, country: 'USA', job_title: 'Manager', department: 'Hr', salary: 300_000)
    create(:employee, country: 'Canada', job_title: 'Software Engineer', department: 'Engineering', salary: 120_000)
  end

  describe 'GET /api/v1/insights/salary_by_country' do
    it 'returns the average average salary by country' do
      get '/api/v1/insights/salary_by_country', params: { country: 'India' }
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body['min']).to eq(100_000)
      expect(body['max']).to eq(200_000)
      expect(body['average']).to eq(150000)
      expect(body['count']).to eq(2)
    end

    it 'returns 400 if country param is missing' do
      get '/api/v1/insights/salary_by_country'
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'GET /api/v1/insights/salary_by_job_title' do
    it 'returns salary stats for a job title in a country' do
      get '/api/v1/insights/salary_by_job_title', params: { country: 'India', job_title: 'Software Engineer' }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      puts body
      expect(body['average']).to eq(150000)
      expect(body['count']).to eq(2)
      expect(body['job_title']).to eq('Software Engineer')
      expect(body['country']).to eq('India')
    end

    it 'returns 400 if params missing' do
      get '/api/v1/insights/salary_by_job_title', params: { country: 'India' }
      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "GET /api/v1/insights/salary_by_department" do
    it "returns salary stats grouped by department for a country" do
      get "/api/v1/insights/salary_by_department", params: { country: "India" }
  
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
  
      engineering = body.find { |r| r["department"] == "Engineering" }
      expect(engineering["average"]).to eq(150000)
      expect(engineering["min"]).to eq(100000)
      expect(engineering["max"]).to eq(200000)
      expect(engineering["count"]).to eq(2)
    end
  
    it "returns 400 if country param missing" do
      get "/api/v1/insights/salary_by_department"
      expect(response).to have_http_status(:bad_request)
    end
  end
  
  describe "GET /api/v1/insights/headcount_by_country" do
    it "returns employee count grouped by country" do
      get "/api/v1/insights/headcount_by_country"
  
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
  
      india = body.find { |r| r["country"] == "India" }
      expect(india["count"]).to eq(2)
    end
  end
end
