module Api
  module V1
    class InsightsController < ApplicationController
      def salary_by_country
        return missing_param("country") unless params[:country].present?

        result = Insights::SalaryStatsService.new(
          country: params[:country]
        ).salary_by_country

        render json: result.merge(country: params[:country])
      end

      def salary_by_job_title
        return missing_param("country and job_title") unless params[:country].present? && params[:job_title].present?

        result = Insights::SalaryStatsService.new(
          country:   params[:country],
          job_title: params[:job_title]
        ).salary_by_job_title

        render json: result.merge(country: params[:country], job_title: params[:job_title])
      end

      def salary_by_department
        return missing_param("country") unless params[:country].present?
      
        result = Insights::SalaryStatsService.new(
          country: params[:country]
        ).salary_by_department
      
        render json: result
      end
      
      def headcount_by_country
        result = Insights::SalaryStatsService.headcount_by_country
        render json: result
      end

      private

      def missing_param(param)
        render json: { error: "#{param} param is required" }, status: :bad_request
      end
    end
  end
end
