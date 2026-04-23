module Insights
  class SalaryStatsService

    def initialize(country:, job_title: nil, department: nil)
      @country = country
      @job_title = job_title
      @department = department
    end

    def salary_by_country
      compute_stats(base_query)
    end

    def salary_by_job_title
      compute_stats(base_query.by_job_title(@job_title))
    end
    
    private

    def base_query
      Employee.in_country(@country)
    end

    def compute_stats(query)
      {
        min:     query.minimum(:salary),
        max:     query.maximum(:salary),
        average: query.average(:salary).to_i,
        count:   query.count
      }
    end
  end
end