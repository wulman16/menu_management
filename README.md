# Menu Management

A Rails API for managing restaurants, menus, and menu items.

## Getting Started

### Prerequisites

* Ruby 3.1.0

### Running Locally

```
git clone git@github.com:wulman16/menu_management.git
cd menu_management
bundle install
rails db:create
rails db:migrate
rails db:seed
rails server
```

You can interact with the API using a tool like [Postman](https://www.postman.com/).

### Running Tests

`rspec` runs all of the model and request specs.

## Usage

### Restaurants

* List all Restaurants
    - GET `/restaurants`
    - Returns a list of all restaurants.
* Get a Single Restaurant
    - GET `/restaurants/:id`
    - Returns detailed information about a specific restaurant, including associated menus.
* Create a New Restaurant
    - POST `/restaurants`
    - Parameters: name (required)
    - Creates a new restaurant and returns the created restaurant data with HTTP status 201 Created.
* Update a Restaurant
    - PUT/PATCH `/restaurants/:id`
    - Parameters: name (required)
    - Updates an existing restaurant and returns the updated restaurant data.
* Delete a Restaurant
    - DELETE `/restaurants/:id`
    - Deletes a specified restaurant and returns HTTP status 204 No Content.

### Menus

* List all Menus for a Restaurant
    - GET `/restaurants/:restaurant_id/menus`
    - Returns all menus associated with a specific restaurant, including details about menu entries and their items.
* Get a Single Menu
    - GET `/restaurants/:restaurant_id/menus/:id`
    - Returns detailed information about a specific menu, including menu entries and menu items.
* Create a New Menu
    - POST `/restaurants/:restaurant_id/menus`
    - Parameters: name (required)
    - Creates a new menu under the specified restaurant and returns the created menu data with HTTP status 201 Created.
* Update a Menu
    - PUT/PATCH `/restaurants/:restaurant_id/menus/:id`
    - Parameters: name (required)
    - Updates an existing menu and returns the updated menu data.
* Delete a Menu
    - DELETE `/restaurants/:restaurant_id/menus/:id`
    - Deletes a specified menu and returns HTTP status 204 No Content.

### Menu Items

* List all Menu Items
    - GET `/menu_items`
    - Returns a list of all menu items.
* Get a Single Menu Item
    - GET `/menu_items/:id`
    - Returns detailed information about a specific menu item.
* Create a New Menu Item
    - POST `/menu_items`
    - Parameters: name (required), description (optional)
    - Creates a new menu item and returns the created menu item data with HTTP status 201 Created.
* Update a Menu Item
    - PUT/PATCH `/menu_items/:id`
    - Parameters: name (required), description (optional)
    - Updates an existing menu item and returns the updated menu item data.
* Delete a Menu Item
    - DELETE `/menu_items/:id`
    - Deletes a specified menu item if it is not associated with any menus. Returns HTTP status 204 No Content or 409 Conflict if it is still associated.

### Menu Entries

* Create a Menu Entry
    - POST `/restaurants/:restaurant_id/menus/:menu_id/menu_entries`
    - Parameters: menu_item_id (required), description (optional), price (required)
    - Creates a new menu entry under the specified menu and returns the created menu entry data with HTTP status 201 Created.
* Delete a Menu Entry
    - DELETE `/restaurants/:restaurant_id/menus/:menu_id/menu_entries/:id`
    - Deletes a specified menu entry and returns HTTP status 204 No Content.

## Assumptions and Limitations

* I interpreted the directive of "`MenuItem` names should not be duplicated in the database" rather strictly. An implementation where `MenuItem` names are unique only within a single `Restaurant` could make sense, but I opted to enforce their uniqueness throughout the application. For this reason, deleting a `Restaurant` also deletes its associated `Menus` and `MenuEntries` but not its associated `MenuItems`.
* A single `Menu` cannot have the same `MenuItem` more than once.
* A `MenuItem` could have a different price depending on what `Menu` it's on. For example, a lunch menu might list a dish from a dinner menu at the same restaurant but at a cheaper price. For this reason, `MenuItem` has only `name` and `description` while the join table `MenuEntry` is responsible for `price`.
* `MenuItems` can exist independently of `Restaurants` and `Menus`. There are drawbacks to having "orphaned" items like this, but it also allows for the periodic addition and removal of certain `MenuItems` by season, availability, etc.
* Prices on `MenuEntries` are formatted with USD in mind. Currencies that don't use two decimal places would not be supported in this imeplementation.
* I did not get to Level 3 of the requirements.
