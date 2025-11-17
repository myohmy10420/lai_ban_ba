class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name
      t.string :address

      t.timestamps
    end
  end
end
