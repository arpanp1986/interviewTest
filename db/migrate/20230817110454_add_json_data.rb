class AddJsonData < ActiveRecord::Migration[7.0]
  def change
    file = File.join(Rails.root, 'app', 'data', 'countries.json')
    data = JSON.parse(File.read(file))
    data.each do |country_data|
      Country.create(data: country_data)
    end
  end
end
