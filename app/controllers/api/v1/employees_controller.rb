module Api
  module V1
    class EmployeesController < ApplicationController

      before_action :set_employee, only: [:show, :update, :destroy]

      def index
        @employees = Employee.all
        render json: { employees: @employees }, status: :ok
      end

      def show
        render json: { employee: @employee }, status: :ok
      end

      def create
        @employee = Employee.create(employee_params)
        if @employee.save
          render json: { employee: @employee }, status: :created
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