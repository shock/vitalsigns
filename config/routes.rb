Rails.application.routes.draw do
  namespace :vital_signs do
    resources :layouts, :controller => "layout_bridge" do
      member do
        get :test
      end
    end
    root :to => 'layout_bridge#index'
  end
end

