require 'rails_helper'

RSpec.describe QueryJsonController do
  context 'search_using_jmespath_expresion gets authentication error' do
    it "verifies that it gets 401 if authentication is not provided" do
      get :search_using_jmespath_expresion, params: {}

      expect(response.status).to eq(401)
    end
  end

  context 'search_using_jmespath_expresion' do
    before do
      expect(controller).to receive(:authenticate_or_request_with_http_basic).and_return(true)
    end
    it "verifies all required params are present" do
      get :search_using_jmespath_expresion, params: {}

      expect(response.status).to eq(422)
      expect(JSON.parse(response.body)).to eq("param is missing or the value is empty: expression")
    end

    it "returns data when expresion is provided" do
      get :search_using_jmespath_expresion, params: { expression: "[?name.common == 'Saudi Arabia']" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(1)
      expect(JSON.parse(response.body)[0]["name"]["official"]).to eq("Kingdom of Saudi Arabia")
    end

    it "returns data when with > expresion" do
      get :search_using_jmespath_expresion, params: { expression: "[?population > `1000000000`]" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).count).to eq(2)
      expect(JSON.parse(response.body)[0]["name"]["common"]).to eq("China")
      expect(JSON.parse(response.body)[1]["name"]["common"]).to eq("India")
    end

  end
end
