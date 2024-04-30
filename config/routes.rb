Rails.application.routes.draw do
  resources :restaurants do
    resources :menus do
      resources :menu_entries, except: %i[update show]
    end
  end

  resources :menu_items
end
