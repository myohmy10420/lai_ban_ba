class FixSchemaIndexesAndNullable < ActiveRecord::Migration[8.0]
  def change
    # employees.user_id 應為 nullable（員工不一定有登入帳號）
    change_column_null :employees, :user_id, true

    # employees.name 應為 NOT NULL
    change_column_null :employees, :name, false

    # 缺少的 index
    add_index :employees, :user_id, if_not_exists: true

    # memberships 唯一約束：同一 user 在同一 account 只能有一個 membership
    add_index :memberships, [:user_id, :account_id], unique: true, if_not_exists: true

    # shifts 常用查詢 index
    add_index :shifts, :starts_at, if_not_exists: true
    add_index :shifts, [:account_id, :starts_at], if_not_exists: true
  end
end
