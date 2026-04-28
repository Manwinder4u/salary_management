module Api
  module V1
    class EmployeesController < ApplicationController

      before_action :set_employee, only: [:show, :update, :destroy]

      def index
        page = params[:page] || 1
        per_page = params[:per_page] || 20
        employees = Employee.order(created_at: :desc).page(page).per(per_page)

        render json: {
          data: employees,
          meta: {
            total_count:  employees.total_count,
            current_page: employees.current_page,
            total_pages:  employees.total_pages,
            per_page:     employees.limit_value
          }
        }
      end

      def show
        render json: { employee: @employee }, status: :ok
      end

      def create
        @employee = Employee.new(employee_params)
        if @employee.save
          render json: @employee, status: :created
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @employee.update(employee_params)
          render json: { employee: @employee }, status: :ok
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if @employee.destroy
          render json: { message: 'Employee deleted successfully' }, status: :ok
        else
          render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Employee not found' }, status: :not_found
      end

      def employee_params
        params.require(:employee).permit(
          :first_name, :last_name, :email, :job_title,
          :department, :country, :salary, :hire_date
        )
      end
    end
  end
end