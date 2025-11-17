class CreateShifts < ActiveRecord::Migration[8.0]
  def change
    create_table :shifts do |t|
      t.references :account, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :required_headcount
      t.string :role_tag
      t.string :source
      t.integer :lock_version

      t.timestamps
    end
  end
end
