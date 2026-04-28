# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

if Employee.count >= 10_000 && ENV['FORCE_RESEED'] != '1'
  puts "Already seeded #{Employee.count} employees. Use FORCE_RESEED=1 to reseed."
  exit
end

puts "Cleaning existing employees..."
Employee.delete_all

puts "Loading name files..."
first_names = File.readlines(Rails.root.join('db/seeds/first_names.txt')).map(&:strip).reject(&:empty?)
last_names  = File.readlines(Rails.root.join('db/seeds/last_names.txt')).map(&:strip).reject(&:empty?)

DEPARTMENTS = %w[Engineering HR Finance Marketing Sales Operations Legal].freeze
JOB_TITLES  = [
  'Software Engineer', 'Senior Engineer', 'Product Manager',
  'HR Manager', 'Data Analyst', 'DevOps Engineer',
  'Financial Analyst', 'Marketing Manager', 'Sales Executive',
  'Operations Manager', 'Legal Counsel', 'UX Designer'
].freeze
COUNTRIES   = %w[India USA UK Canada Australia Germany France Singapore].freeze

BATCH_SIZE  = 1_000
TOTAL       = 10_000

puts "Seeding #{TOTAL} employees in batches of #{BATCH_SIZE}..."
records     = [] # empty array

start_time = Time.now

TOTAL.times do # loop 10K times
  first_name = first_names.sample
  last_name  = last_names.sample

  records << {
    first_name: first_name,
    last_name:  last_name,
    email:      "#{first_name.downcase}.#{last_name.downcase}#{rand(99_999)}@company.com",
    department: DEPARTMENTS.sample,
    job_title:  JOB_TITLES.sample,
    country:    COUNTRIES.sample,
    salary:     rand(30_000..200_000),
    hire_date:  rand(5.years.ago.to_date..Date.today),
    created_at: Time.now,
    updated_at: Time.now
  }

  # if array size is 1000 insert recods 
  # this will happen 10 times
  # here, we are hitting Db only 10 times
  if records.size == BATCH_SIZE 
    Employee.insert_all(records)
    puts "Inserted #{Employee.count} employees..."
    records = [] # empty the array again
  end
end

Employee.insert_all(records) if records.any?
puts "Done! Total: #{Employee.count} employees"

end_time = Time.now
puts "Execution time: #{end_time - start_time} seconds"
