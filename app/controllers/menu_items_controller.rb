class MenuItemsController < ApplicationController
  before_action :set_restaurant
  before_action :set_menu
  before_action :set_menu_item, only: %i[show update destroy]

  def index
    @menu_items = @menu.menu_items
    render json: @menu_items
  end

  def show
    render json: @menu_item
  end

  def create
    @menu_item = MenuItem.find_or_initialize_by(name: menu_item_params[:name])

    if @menu_item.new_record?
      @menu_item.assign_attributes(menu_item_params)

      if @menu_item.save
        @menu.menu_entries.create!(menu_item: @menu_item)
        render json: @menu_item, status: :created, location: [@restaurant, @menu, @menu_item]
      else
        render json: @menu_item.errors, status: :unprocessable_entity
      end
    else
      # Check if the menu item is already associated with the current menu
      existing_menu_entry = @menu.menu_entries.find_by(menu_item: @menu_item)
      if existing_menu_entry
        render json: { error: 'Menu item already exists on this menu.' }, status: :conflict
        return
      end

      # Associate the existing item with the current menu
      @menu.menu_entries.create!(menu_item: @menu_item)
      render json: @menu_item, status: :created, location: [@restaurant, @menu, @menu_item]
    end
  end

  def update
    if @menu_item.update(menu_item_params)
      render json: @menu_item, status: :ok
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # Remove the association between the menu item and the current menu only
    @menu.menu_entries.where(menu_item_id: @menu_item.id).destroy_all

    # Check if the menu item is no longer associated with any other menus
    @menu_item.destroy if @menu_item.menus.empty?

    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu
    @menu = @restaurant.menus.find(params[:menu_id])
  end

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price)
  end
end
