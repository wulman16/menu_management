class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[show update destroy]

  def index
    @menu_items = MenuItem.all
    render json: @menu_items
  end

  def show
    render json: @menu_item
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      render json: @menu_item, status: :created, location: @menu_item
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
    # Check if the menu item is associated with any menus
    if @menu_item.menus.any?
      # If associated, do not delete and return a conflict status
      render json: { error: 'Menu item is still associated with one or more menus.' }, status: :conflict
    else
      # If no associations, proceed to destroy
      @menu_item.destroy
      head :no_content
    end
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description)
  end
end
