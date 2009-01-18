ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'site', :action => 'index'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil 

  map.resources :people, :member => { :suspend   => :put,
                                      :unsuspend => :put,
                                      :purge     => :delete }

  map.resources :users
  map.resources :passwords
  map.resource :session

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
