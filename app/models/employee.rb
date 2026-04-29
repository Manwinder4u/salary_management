class Employee < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :job_title, presence: true
  validates :department, presence: true
  validates :country, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates :hire_date, presence: true


  scope :in_country, ->(country) { where(country: country) }
  scope :by_job_title, ->(job_title) { where(job_title: job_title) }
  scope :search_by_name, ->(query) {
    where("first_name ILIKE :q OR last_name ILIKE :q", q: "%#{query}%")
  }
end
