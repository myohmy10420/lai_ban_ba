class CreateLocationBusinessHours < ActiveRecord::Migration[8.1]
  def change
    create_table :location_business_hours do |t|
      t.references :location, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.time :opens_at
      t.time :closes_at
      t.boolean :is_closed, null: false, default: false

      t.timestamps
    end

    add_index :location_business_hours, [:location_id, :day_of_week], unique: true
  end
end
