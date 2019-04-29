class CreateFlights < ActiveRecord::Migration[5.0]
  def change
    create_table :flights do |t|
      t.integer :from_airport_id
      t.integer :to_airport_id
      t.datetime :departure
      t.string :duration

      t.timestamps
    end
  end
end