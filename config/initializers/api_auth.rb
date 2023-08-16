# config/initializers/basic_auth.rb
basic_auth_credentials = YAML.load_file("#{Rails.root}/config/api_credentials.yml")[Rails.env]
Rails.application.config.middleware.use(Rack::Auth::Basic) do |username, password|
  username == basic_auth_credentials['username'] && password == basic_auth_credentials['password']
end
