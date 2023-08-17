class QueryJsonController < ApplicationController
  before_action :authenticate

  def search_using_jmespath_expresion
    begin
      params.require(:expression)

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
        render json: sorted_result.to_json, status: :unprocessable_entity
      end
    rescue => e
      render json: {"Error": e.message}.to_json, status: :unprocessable_entity
    end
  end

  def country_by_name_using_jsonb
    begin
      params.require(:country_name)
      country = Country.country_by_name(params[:country_name])

      if country.present?
        paginated_data = Kaminari.paginate_array(country).page(params[:page]).per(params[:per])
        render json: paginated_data.to_json, status: :ok
      else
        render json: {"Message": "No country with Name: #{params[:country_name]}"}.to_json, status: :ok
      end
    rescue => e
      render json: {"Error": e.message}.to_json, status: :unprocessable_entity
    end
  end

  def search_and_sort_using_jsonb
    begin
      params.require(:data_type) && params.require(:sort_by) && params.require(:order_by)

      result = if params[:data_type] == 'integer'
              Country.sorted_list_by_for_int(params[:sort_by], params[:order_by])
            else
              Country.sorted_list_by_for_text(params[:sort_by], params[:order_by])
            end
            if result.present?
              paginated_data = Kaminari.paginate_array(result).page(params[:page]).per(params[:per])
              render json: paginated_data.to_json, ststus: :ok
            else
              render json: { "Message": "No data for provides search #{params[:sort_by]}"}
            end
    rescue => e
      render json: {"Error": e.message}.to_json, status: :unprocessable_entity
    end
  end

private

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
