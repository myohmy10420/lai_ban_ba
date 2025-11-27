# == Schema Information
#
# Table name: shift_assignments
#
#  id                  :bigint           not null, primary key
#  assigned_at         :datetime
#  status              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint           not null
#  assigned_by_user_id :bigint
#  employee_id         :bigint           not null
#  shift_id            :bigint           not null
#
# Indexes
#
#  index_shift_assignments_on_account_id   (account_id)
#  index_shift_assignments_on_employee_id  (employee_id)
#  index_shift_assignments_on_shift_id     (shift_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (shift_id => shifts.id)
#
class ShiftAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :shift
  belongs_to :employee
end
