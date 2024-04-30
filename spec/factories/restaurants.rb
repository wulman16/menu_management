FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
  end
end
