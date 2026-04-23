require 'rails_helper'

RSpec.describe Insights::SalaryStatsService do
  before do
    create(:employee, country: 'India', job_title: 'Engineer', department: 'Engineering', salary: 50_000)
    create(:employee, country: 'India', job_title: 'Engineer', department: 'Engineering', salary: 70_000)
    create(:employee, country: 'India', job_title: 'Manager', department: 'HR', salary: 90_000)
    create(:employee, country: 'USA',   job_title: 'Engineer', department: 'Engineering', salary: 120_000)
  end

  describe '#salary_by_country' do
    it 'returns min, max, average and count for a country' do
      results = described_class.new(country: 'India').salary_by_country

      expect(results[:min]).to eq(50_000)
      expect(results[:max]).to eq(90_000)
      expect(results[:average]).to eq(70_000)
      expect(results[:count]).to eq(3)
    end
  end

  describe '#salary_by_job_title' do
    it 'returns average salary for a job title in a country' do
      result = described_class.new(country: 'India', job_title: 'Engineer').salary_by_job_title

      expect(result[:average]).to eq(60_000)
      expect(result[:count]).to eq(2)
    end
  end
end
