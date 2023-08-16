class QueryJsonController < ApplicationController
  before_action :authenticate

  def search_using_jmespath_expresion
    begin
      params.require(:expression)
    # Expressions
    #[?name.common == 'Iran']
    # [?population > `83992953`] || [?name.common == `Saudi Arabia`]
    #[?languages.eng == 'English'].name.common
    #[?area == `9706961.0`]
      result = JMESPath.search(params[:expression], data)
      paginated_data = Kaminari.paginate_array(result).page(params[:page]).per(params[:per])
      render json: paginated_data, status: :ok
    rescue => e
      render json: e.message.to_json, status: :unprocessable_entity
    end
  end

  def sort_data_by_desired_key
    begin
      params.require(:sort_by) && params.require(:order_by)
      sorted_result = sort_by_expression(data)

      if sort_by_expression(data).present?
        result =  if params[:order_by] == "desc"
                    sorted_result.reverse.map {|data| data["name"]["common"]}
                  else
                    sorted_result.map {|data| data["name"]["common"]}
                  end
        paginated_data = Kaminari.paginate_array(result).page(params[:page]).per(params[:per])
        render json: paginated_data.to_json, status: :ok
      else
        render json: "No result for your expression, please check your expression!".to_json, status: :ok
      end
    rescue => e
      render json: e.message.to_json, status: :unprocessable_entity
    end
  end

  def sort_by_expression(data)
    JMESPath.search("sort_by(@, &#{params[:sort_by]})", data)
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
