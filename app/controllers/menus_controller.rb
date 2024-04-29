class MenusController < ApplicationController
  before_action :set_menu, only: :show
  
  def index
    @menus = Menu.all
    render json: @menus
  end
  
  def show
    render json: @menu
  end
  
  def create
    @menu = Menu.new(menu_params)
    if @menu.save
      render json: @menu, status: :created, location: @menu
    else
      render json: @menu.errors, status: :unprocessable_entity
    end
  end
  
  private

  def set_menu
    @menu = Menu.find(params[:id])
  end
  
  def menu_params
    params.require(:menu).permit(:name)
  end
end
