Rails.application.routes.draw do




  devise_for :users , controllers: {
      registrations: 'users/registrations'
  }


  root 'welcome#welcome'
  get 'welcome/welcome'
  resources :products
  resources :users

  get '/users/reset_password/:id' , to: 'users#reset_password'
  get '/users/active/:id' , to: 'users#active'
  get '/users/:id' , to: 'users#show'
  get '/tree/:id' , to: 'tree#index'
  get '/welcome/:id' , to: 'welcome#index'

    get "/index.html" => "static#index"
    get "/index2.html" => "static#index2"
    get "/index3.html" => "static#index3"
    get "/form.html" => "static#form"
    get "/form_advanced.html" => "static#form_advanced"
    get "/tables.html" => "static#tables"
    get "/tables_dynamic.html" => "static#tables_dynamic"
    get "/general_elements.html" => "static#general_elements"
    get "/media_gallery.html" => "static#media_gallery"
    get "/typography.html" => "static#typography"
    get "/icons.html" => "static#icons"
    get "/glyphicons.html" => "static#glyphicons"
    get "/widgets.html" => "static#widgets"
    get "/invoice.html" => "static#invoice"
    get "/inbox.html" => "static#inbox"
    get "/calendar.html" => "static#calendar"
    get "/chartjs.html" => "static#chartjs"
    get "/chartjs2.html" => "static#chartjs2"
    get "/morisjs.html" => "static#morisjs"
    get "/echarts.html" => "static#echarts"
    get "/other_charts.html" => "static#other_charts"
    get "/fixed_sidebar.html" => "static#fixed_sidebar"
    get "/fixed_footer.html" => "static#fixed_footer"
    get "/kitchen_sink" => "static#kitchen_sink"
    get "/kitchen8_sink" => "static#kitchen8_sink"
    get   '/',                                    to: "static#index"
    get "/firms/mother_firms",                        to:'firms#mother_firms'
    get "/firms/_categories",                        to:'firms#_categories'

end
