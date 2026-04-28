require 'rails_helper'

RSpec.describe Employee, type: :model do
 describe 'validations' do
  it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:job_title) }
    it { should validate_presence_of(:department) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:salary) }
    it { should validate_presence_of(:hire_date) }
    it { should validate_numericality_of(:salary).is_greater_than(0) }
 end
end
