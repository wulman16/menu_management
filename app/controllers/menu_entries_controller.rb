class MenuEntriesController < ApplicationController
  before_action :set_menu

  def create
    @menu_entry = @menu.menu_entries.new(menu_entry_params)
    if @menu_entry.save
      render json: @menu_entry, status: :created
    else
      render json: @menu_entry.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_entry = @menu.menu_entries.find(params[:id])
    @menu_entry.destroy
    head :no_content
  end

  private

  def set_menu
    @restaurant = Restaurant.find(params[:restaurant_id])
    @menu = @restaurant.menus.find(params[:menu_id])
  end

  def menu_entry_params
    params.require(:menu_entry).permit(:menu_item_id, :description, :price)
  end
end
