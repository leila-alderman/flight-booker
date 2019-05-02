class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :flight, foreign_key: true
      t.integer :num_passengers
      t.integer :total_price
      t.string :payment_method_token

      t.timestamps
    end
  end
end
