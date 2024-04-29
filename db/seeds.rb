menus = Menu.create([
  { name: 'Breakfast Menu' },
  { name: 'Lunch Menu' },
  { name: 'Dinner Menu' }
])

menus.each do |menu|
  menu.menu_items.create([
    { name: 'Pancakes', description: 'Delicious fluffy pancakes served with maple syrup.', price: 5.99 },
    { name: 'Black Bean Burger', description: 'Classic savory burger with lettuce, tomato, and onion.', price: 8.99 },
    { name: 'Salad', description: 'Fresh garden salad with mixed greens and balsamic vinaigrette.', price: 6.49 }
  ])
end