class Workday < ApplicationRecord
  belongs_to :user
  
  validates :job_title, presence: true
  validates :industry, presence: true
  validates :description, presence: true
end
