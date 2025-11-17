class CreateShiftAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :shift_assignments do |t|
      t.references :account, null: false, foreign_key: true
      t.references :shift, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :status
      t.bigint :assigned_by_user_id
      t.datetime :assigned_at

      t.timestamps
    end
  end
end
