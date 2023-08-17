require 'rails_helper'

RSpec.describe QueryJsonController do
  context 'search using jmespath expresion' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :search_using_jmespath_expresion, params: {}

      expect(response.status).to eq(401)
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

  context 'search for filtered and sorted data' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :sort_data_by_desired_key, params: {}

      expect(response.status).to eq(401)
    end

    it "verifies that all required params are present" do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).twice.and_return(true)

      get :sort_data_by_desired_key, params: {}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("param is missing or the value is empty: sort_by")

      get :sort_data_by_desired_key, params: { sort_by: "foo"}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("param is missing or the value is empty: order_by")
    end

    it 'returns message if expression is not a valid expression' do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "population`]", order_by: "desc" }

      expect(JSON.parse(response.body)).to eq("unknown token \"])\"")
    end

    it 'returns error message when trying to apply expression on any other object than array' do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)

      get :sort_data_by_desired_key, params: { sort_by: "foo", order_by: "desc" }

      expect(JSON.parse(response.body)).to eq("function sort() expects values to be an array of numbers or integers")
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

end
