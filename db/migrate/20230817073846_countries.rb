class Countries < ActiveRecord::Migration[7.0]
  def change
    create_table :countries do |t|
      t.jsonb :data, null: false, default: {}
      # Add more columns as needed

      t.timestamps
    end
  end
end
