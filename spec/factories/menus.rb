FactoryBot.define do
  factory :menu do
    name { 'Menu' }
    
    trait :lunch do
      name { 'Lunch' }
    end

    trait :dinner do
      name { 'Dinner' }
    end

    trait :drinks do
      name { 'Drinks' }
    end
  end
end