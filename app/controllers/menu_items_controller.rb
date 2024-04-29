class MenuItemsController < ApplicationController
  before_action :set_menu
  before_action :set_menu_item, only: :show
  
  def index
    render json: @menu.menu_items
  end
  
  def show
    render json: @menu_item
  end
  
  def create
    @menu_item = @menu.menu_items.new(menu_item_params)
    if @menu_item.save
      render json: @menu_item, status: :created, location: menu_menu_item_url(@menu, @menu_item)
    else
      render json: @menu_item.errors, status: :unprocessable_entity
    end
  end
  
  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_menu_item
    @menu_item = @menu.menu_items.find(params[:id])
  end
  
  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price)
  end
end
