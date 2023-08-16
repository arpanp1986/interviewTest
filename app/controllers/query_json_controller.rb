class QueryJsonController < ApplicationController
  before_action :authenticate

  def search_using_jmespath_expresion
    params.require(:expression)
    # binding.break
    # Expressions
    #[?name.common == 'Iran']
    # [?population > `83992953`] || [?name.common == `Saudi Arabia`]
    #[?languages.eng == 'English'].name.common
    #[?area == `9706961.0`]

    result = JMESPath.search(params[:expression], data)
    paginated_data = Kaminari.paginate_array(result).page(params[:page]).per(params[:per])
    render json: paginated_data, status: :ok
  end

  def search_by_country_name

  end

  def search_by_population

  end

  def search_by_language

  end

  def search_by_area

  end

  def data
    file = File.join(Rails.root, 'app', 'data', 'countries.json')
    JSON.parse(File.read(file))
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == basic_auth_credentials['username'] && password == basic_auth_credentials['password']
    end
  end
  def basic_auth_credentials
    YAML.load_file("#{Rails.root}/config/api_credentials.yml")[Rails.env]
  end
end
