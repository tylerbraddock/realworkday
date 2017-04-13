FactoryGirl.define do
  factory :workday do
    job_title "Registered Nurse"
    industry "Healthcare"
    description "I do this and I do that."
    association :user
  end

  factory :user do
    sequence :username do |n|
      "Pretzel#{n}"
    end
    sequence :email do |n|
      "fakeEmail#{n}@gmail.com"
    end
    password "secretPassword"
    password_confirmation "secretPassword"
  end
end
