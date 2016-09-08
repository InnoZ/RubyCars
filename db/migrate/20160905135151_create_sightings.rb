class CreateSightings < ActiveRecord::Migration
  def change
    create_table :sightings do |t|
      t.string :provider, null: false
      t.string :city, null: false
      t.string :key
      t.datetime :first_seen_at, null: false
      t.datetime :last_seen_at, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.integer :fuel_level
      t.boolean :stationary, null: false, default: false
      t.integer :price
      t.string  :vehicle_type, null: false, default: 'car'
      t.string :scraper, null: false
    end
  end
end
