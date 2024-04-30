class MenusController < ApplicationController
  before_action :set_restaurant
  before_action :set_menu, only: %i[show update destroy]

  def index
    @menus = @restaurant.menus
    render json: format_json(@menus)
  end

  def show
    render json: format_json(@menu)
  end

  def create
    @menu = @restaurant.menus.new(menu_params)
    if @menu.save
      render json: format_json(@menu), status: :created, location: [@restaurant, @menu]
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  def update
    if @menu.update(menu_params)
      render json: format_json(@menu), status: :ok
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end

  def destroy
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

  def format_json(menu)
    menu.as_json(include: {
                   menu_entries: {
                     include: {
                       menu_item: {
                         only: %i[id name description]
                       }
                     },
                     only: %i[id price]
                   }
                 })
  end
end
