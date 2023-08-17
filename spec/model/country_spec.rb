require 'rails_helper'

RSpec.describe Country do

  before(:all) do
    file = File.join(Rails.root, 'spec', 'data', 'countries_test_data.json')
    data = JSON.parse(File.read(file))
    data.each do |country_data|
      Country.create(data: country_data)
    end
  end

  describe '#sorted_list_by_for_int' do
    it 'returns the country object based on provided name' do
      country = described_class.country_by_name("Saudi Arabia").last

      expect(country.data["name"]["common"]).to eq('Saudi Arabia')
    end
  end

  describe '#sorted_list_by_for_int' do
    it 'returns sorted list in descending order when value type is integer' do
      country = described_class.sorted_list_by_for_int("population", "desc")

      expect(country.length).to eq(4)
      expect(country.first).to eq("United Arab Emirates")
      expect(country.last).to eq("Iran")
    end

    it 'returns sorted list in ascending order when value type is integer' do
      country = described_class.sorted_list_by_for_int("population", "asc")

      expect(country.length).to eq(4)
      expect(country.first).to eq("Iran")
      expect(country.last).to eq("United Arab Emirates")
    end
  end

  describe '#sorted_list_by_for_int' do
    it 'returns sorted list in descending order when value type is non integer' do
      country = described_class.sorted_list_by_for_text("ccn3", "desc")

      expect(country.length).to eq(4)
      expect(country.first).to eq("United Arab Emirates")
      expect(country.last).to eq("Cameroon")
    end

    it 'returns sorted list in ascending order when value type is integer' do
      country = described_class.sorted_list_by_for_text("ccn3", "asc")

      expect(country.length).to eq(4)
      expect(country.first).to eq("Cameroon")
      expect(country.last).to eq("United Arab Emirates")
    end
  end
end
