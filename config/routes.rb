Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'countries', to: 'query_json#search_using_jmespath_expresion'
  get 'sorted_data', to: 'query_json#sort_data_by_desired_key'

  get 'countries_jsonb', to: 'query_json#country_by_name_using_jsonb'
  get 'search_sort_jsonb', to: 'query_json#search_and_sort_using_jsonb'

end
