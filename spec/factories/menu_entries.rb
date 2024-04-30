FactoryBot.define do
  factory :menu_entry do
    menu { nil }
    menu_item { nil }
    price { Faker::Commerce.price(range: 10.0..50.0) }
  end
end
