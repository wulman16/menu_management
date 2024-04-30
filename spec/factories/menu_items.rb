FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "#{Faker::Food.dish} #{n}" }
    description { Faker::Food.description }
  end
end
