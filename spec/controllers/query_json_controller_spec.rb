require 'rails_helper'

RSpec.describe QueryJsonController do
  context '#search_using_jmespath_expresion' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :search_using_jmespath_expresion, params: {}

      expect(response.status).to eq(401)
      expect(response.body).to eq("HTTP Basic: Access denied.\n")
    end

    it "verifies all required params are present" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_using_jmespath_expresion, params: {}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("param is missing or the value is empty: expression")
    end

    it "returns data when expresion is provided" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_using_jmespath_expresion, params: { expression: "[?name.common == 'Saudi Arabia']" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(1)
      expect(JSON.parse(response.body)[0]["name"]["official"]).to eq("Kingdom of Saudi Arabia")
    end

    it "returns data when with > expresion" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_using_jmespath_expresion, params: { expression: "[?population > `1000000000`]" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(2)
      expect(JSON.parse(response.body)[0]["name"]["common"]).to eq("China")
      expect(JSON.parse(response.body)[1]["name"]["common"]).to eq("India")
    end

    it "uses pagination" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_using_jmespath_expresion, params: { expression: "[?population > `0`]", page: 1, per: 7 }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(7)
    end
  end

  context '#sort_data_by_desired_key' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :sort_data_by_desired_key, params: {}

      expect(response.status).to eq(401)
      expect(response.body).to eq("HTTP Basic: Access denied.\n")
    end

    it "verifies error message if sort_by params is missing" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: {}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: sort_by")
    end

    it "verifies error message if order_by params is missing" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "foo"}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: order_by")
    end

    it 'returns message if expression is not a valid expression' do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "population`]", order_by: "desc" }

      expect(JSON.parse(response.body)).to eq("Error"=>"unknown token \"])\"")
    end

    it 'returns error message when trying to apply expression on any other object than array' do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "foo", order_by: "desc" }

      expect(JSON.parse(response.body)).to eq("Error" => "function sort() expects values to be an array of numbers or integers")
    end

    it 'returns message if expression is valid but did not return any result' do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      allow_any_instance_of(QueryJsonController).to receive(:sort_by_expression).and_return([])
      get :sort_data_by_desired_key, params: { sort_by: "foo", order_by: "desc" }

      expect(JSON.parse(response.body)).to eq([])
    end

    it "retuns result successfully with pagination" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "population", order_by: "desc", page: 1, per: 11 }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(11)
    end
  end

  context '#country_by_name_using_jsonb' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :country_by_name_using_jsonb, params: {}

      expect(response.status).to eq(401)
      expect(response.body).to eq("HTTP Basic: Access denied.\n")
    end

    it "verifies all required params are present" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :country_by_name_using_jsonb, params: {}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: country_name")
    end

    it "returns message if no country is present with provided name" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
      allow(Country).to receive(:country_by_name).and_return([])
      get :country_by_name_using_jsonb, params: { country_name: "India"}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq("Message"=>"No country with Name: India")
    end

    it "returns country if present with provided name" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
      allow(Country).to receive(:country_by_name).and_return(double("India"))
      get :country_by_name_using_jsonb, params: { country_name: "India"}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["name"]).to eq("India")
    end
  end

  context '#search_and_sort_using_jsonb' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :search_and_sort_using_jsonb, params: {}

      expect(response.status).to eq(401)
      expect(response.body).to eq("HTTP Basic: Access denied.\n")
    end

    it "verifies error message if data_type params is missing" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_and_sort_using_jsonb, params: { sort_by: "foo", order_by: "desc" }

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: data_type")
    end

    it "verifies error message if sort_by params is missing" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_and_sort_using_jsonb, params: { data_type: "foo", order_by: "bar" }

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: sort_by")
    end

    it "verifies error message if order_by params is missing" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :search_and_sort_using_jsonb, params: { data_type: "foo", sort_by: "bar" }

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("Error" => "param is missing or the value is empty: order_by")
    end


    it "returns message if no data for provided search is present for integer data type" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
      allow(Country).to receive(:sorted_list_by_for_int).and_return([])
      get :search_and_sort_using_jsonb, params: { data_type: "integer", sort_by: "population", order_by: "desc"}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq("Message"=>"No data for provides search population")
    end

    it "returns message if no data for provided search is present for data type other than integer" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
      allow(Country).to receive(:sorted_list_by_for_text).and_return([])
      get :search_and_sort_using_jsonb, params: { data_type: "notinteger", sort_by: "population", order_by: "desc"}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq("Message"=>"No data for provides search population")
    end

    it "returns data successfully" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
      allow(Country).to receive(:sorted_list_by_for_int).and_return([{"foo": "bar"}])
      get :search_and_sort_using_jsonb, params: { data_type: "integer", sort_by: "population", order_by: "desc"}

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)).to eq([{"foo"=>"bar"}])
    end
  end

end
