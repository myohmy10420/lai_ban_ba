class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.references :account, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone
      t.date :start_on
      t.date :end_on
      t.string :status

      t.timestamps
    end
  end
end
