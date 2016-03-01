class CreateTables < ActiveRecord::Migration
  def change
    create_table :regions, id: false do |t|
      t.string :id, null: false
      t.timestamps null: false
    end
    execute "ALTER TABLE regions ADD PRIMARY KEY (id);"
    add_index :regions, :id, unique: true

    create_table :companies, id: false do |t|
      t.string :id, null: false
      t.timestamps null: false
    end
    execute "ALTER TABLE companies ADD PRIMARY KEY (id);"
    add_index :companies, :id, unique: true

    create_table :providers, id: false do |t|
      t.references :company, type: "string", foreign_key: :id
      t.string :company_id, null: false
      t.string :id, null: false
      t.string :name, null: false
      t.float :centroid_latitude
      t.float :centroid_longitude
      t.string :extra

      t.timestamps null: false
    end
    execute "ALTER TABLE providers ADD PRIMARY KEY (id);"
    add_index :providers, :id, unique: true

    create_table :stations, id: false do |t|
      t.references :provider, type: "string", foreign_key: :id
      t.references :region, type: "string", foreign_key: :id
      t.string :provider_id, null: false
      t.string :region_id, null: false
      t.string :id, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.integer :cars, null: false
      t.string :extra

      t.timestamps null: false
    end
    execute "ALTER TABLE stations ADD PRIMARY KEY (id);"
    add_index :stations, :id, unique: true
  end
end
