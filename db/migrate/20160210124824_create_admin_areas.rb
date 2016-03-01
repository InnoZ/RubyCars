class CreateAdminAreas < ActiveRecord::Migration
  def change
    create_table :admin_areas do |t|
      t.geometry :geom, srid: 4326
      t.string :name
      t.string :region
      t.string :admin
    end
  end
end
