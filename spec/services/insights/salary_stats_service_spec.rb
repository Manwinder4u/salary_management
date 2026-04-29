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

    it "returns min, max, average and count for a job title in a country" do
      result = described_class.new(country: "India", job_title: "Engineer").salary_by_job_title

      expect(result[:average]).to eq(60_000)
      expect(result[:count]).to eq(2)
      expect(result[:min]).to eq(50_000)
      expect(result[:max]).to eq(70_000)
    end
  end

  describe "#salary_by_department" do
    it "returns salary stats grouped by department for a country" do
      result = described_class.new(country: "India").salary_by_department

      engineering = result.find { |r| r[:department] == "Engineering" }
      expect(engineering[:average]).to eq(60_000)
      expect(engineering[:min]).to eq(50_000)
      expect(engineering[:max]).to eq(70_000)
      expect(engineering[:count]).to eq(2)
    end
  end

  describe "#headcount_by_country" do
    it "returns employee count grouped by country" do
      result = described_class.headcount_by_country

      expect(result).to be_an(Array)

      india = result.find { |r| r[:country] == "India" }
      expect(india[:count]).to eq(3)
    end
  end
end
