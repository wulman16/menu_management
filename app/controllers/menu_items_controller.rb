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
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      @menu.menu_entries.create(menu_item: @menu_item)
      render json: @menu_item, status: :created, location: [@restaurant, @menu, @menu_item]
    else
      render json: @menu_item.errors, status: :unprocessable_entity
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
    @menu.menu_entries.where(menu_item_id: @menu_item.id).destroy_all
    @menu_item.destroy
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
