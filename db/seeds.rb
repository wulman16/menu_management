restaurant_names = ['La Fonda', 'East Pole Coffee', 'Surin of Thailand']
menu_names = ['Breakfast Menu', 'Lunch Menu', 'Dinner Menu']

restaurants = restaurant_names.map do |name|
  Restaurant.find_or_create_by(name:).tap do |restaurant|
    menu_names.each do |menu_name|
      restaurant.menus.find_or_create_by(name: menu_name)
    end
  end
end

menu_item_attributes = [
  { name: 'Pancakes', description: 'Delicious fluffy pancakes served with maple syrup.' },
  { name: 'Black Bean Burger', description: 'Classic savory burger with lettuce, tomato, and onion.' },
  { name: 'Salad', description: 'Fresh garden salad with mixed greens and balsamic vinaigrette.' }
]

menu_items = menu_item_attributes.map do |attrs|
  MenuItem.find_or_create_by(name: attrs[:name]) do |item|
    item.description = attrs[:description]
  end
end

restaurants.each do |restaurant|
  restaurant.menus.each do |menu|
    menu_items.each do |item|
      MenuEntry.find_or_create_by(menu:, menu_item: item, price: rand(500..2000) / 100.0)
    end
  end
end
