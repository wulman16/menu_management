class MenusController < ApplicationController
  before_action :set_restaurant
  before_action :set_menu, only: %i[show update destroy]

  def index
    @menus = @restaurant.menus
    render json: @menus
  end

  def show
    render json: @menu, include: :menu_items
  end

  def create
    @menu = @restaurant.menus.new(menu_params)
    if @menu.save
      render json: @menu, status: :created, location: [@restaurant, @menu]
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update(menu_params)
      render json: @menu, include: :menu_items
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # Delete menu items not associated with any other menus
    @menu.menu_items.each do |menu_item|
      menu_item.destroy if menu_item.menus.count == 1
    end

    @menu.destroy
    head :no_content
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_menu
    @menu = @restaurant.menus.find(params[:id])
  end

  def menu_params
    params.require(:menu).permit(:name)
  end
end
