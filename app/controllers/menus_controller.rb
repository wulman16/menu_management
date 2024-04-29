class MenusController < ApplicationController
  before_action :set_menu, only: [:show, :update, :destroy]
  
  def index
    @menus = Menu.all
    render json: @menus, include: :menu_items
  end
  
  def show
    render json: @menu, include: :menu_items
  end
  
  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      render json: @menu, status: :created, location: @menu
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
    @menu.destroy
    head :no_content
  end
  
  private

  def set_menu
    @menu = Menu.find(params[:id])
  end
  
  def menu_params
    params.require(:menu).permit(:name, :restaurant_id)
  end
end
