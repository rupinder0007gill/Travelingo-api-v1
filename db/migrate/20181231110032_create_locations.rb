class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :flag
      t.string :image
      t.string :season
      t.integer :trip_id

      t.timestamps
    end
  end
end
