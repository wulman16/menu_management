class MenuItemsController < ApplicationController
  before_action :set_menu
  before_action :set_menu_item, only: :show
  
  def index
    render json: @menu.menu_items
  end
  
  def show
    render json: @menu_item
  end
  
  private

  def set_menu
    @menu = Menu.find(params[:menu_id])
  end

  def set_menu_item
    @menu_item = @menu.menu_items.find(params[:id])
  end
end
