module Insights
  class SalaryStatsService
    def initialize(country:, job_title: nil, department: nil)
      @country = country
      @job_title = job_title
    end

    def salary_by_country
      compute_stats(base_query)
    end

    def salary_by_job_title
      compute_stats(base_query.by_job_title(@job_title))
    end

    def salary_by_department
      base_query
        .group(:department)
        .select(
          "department",
          "MIN(salary) AS min",
          "MAX(salary) AS max",
          "ROUND(AVG(salary)) AS average",
          "COUNT(*) AS count"
        )
        .map { |r| format_department(r) }
    end

    def self.headcount_by_country
      Employee.group(:country).count
              .map { |country, count| { country: country, count: count } }
              .sort_by { |r| -r[:count] }
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

    def format_department(record)
      {
        department: record.department,
        min:        record.min,
        max:        record.max,
        average:    record.average.to_i,
        count:      record.count
      }
    end
  end
end
