# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :ig_id do |n|
    ((Random.rand(100000) * Random.rand(100000)) / n ).to_s
  end

  sequence :created_time do |n|
    "#{n}#{n}#{n}"
  end

  factory :like do
    caption Faker::Lorem.sentence
    ig_id
    low_res_image Faker::Internet.url
    standard_res_image Faker::Internet.url
    thubmbnail Faker::Internet.url
    web_url Faker::Internet.url
    created_time
    filter "DemoFilter"
  end
end
