# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :uid do |n|
    ((Random.rand(100000) * Random.rand(100000)) / n ).to_s
  end

  factory :user do
    name Faker::Name.name
    email Faker::Internet.email
    nickname Faker::Internet.user_name
    provider "instagram"
    uid
  end
end
