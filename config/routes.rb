Rails.application.routes.draw do
  get 'settings/index'

  devise_for :users, :controllers => { :sessions =>  'users/sessions' }

	#resources :users, :only => [:index, :show], :constraints => { :id => /[^\/]+/ } do
	resources :users, :only => [:index, :show] do
		get 'settings'
		resources :issues, :only => [:show, :create, :new,:update, :edit] do
			collection do
				get '/' => 'issues#user_issues'
			end
		end
	end

	resources :issues, :only => [:index, :show] do
		resources :issue_trackers, :only => [:new, :create]
		resources :issue_extra_infos, :only => [:index] do
			collection do
				patch '/' => 'issue_extra_infos#update'
			end
		end
		collection do
			post 'search'
		end
	end

	resources :issue_extra_infos, :only => [:new]

	resources :issue_extra_info_details, :only => [:index, :new] do
		collection do
			patch '/' => 'issue_extra_info_details#update'
		end
	end

	# manage admin users
	resources :admins, :only => [:index, :create, :destroy] do
		collection do
			get 'search'
			get 'report'
		end
	end

	resources :settings, :only => [:index]

	get 'welcome/test'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'welcome#index'
  root 'issues#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
