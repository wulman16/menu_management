class MenusController < ApplicationController
  before_action :set_menu, only: :show
  
  def index
    @menus = Menu.all
    render json: @menus
  end
  
  def show
    render json: @menu
  end
  
  private

  def set_menu
    @menu = Menu.find(params[:id])
  end
end
