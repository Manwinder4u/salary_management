FactoryBot.define do
  factory :employee do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email      { Faker::Internet.unique.email }
    job_title  { Faker::Job.title }
    department { Faker::Commerce.department }
    country    { Faker::Address.country }
    salary     { Faker::Number.between(from: 30_000, to: 200_000) }
    hire_date  { Faker::Date.between(from: 5.years.ago, to: Date.today) }
  end
end
