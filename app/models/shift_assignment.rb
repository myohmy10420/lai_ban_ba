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
  belongs_to :assigned_by_user, class_name: "User", foreign_key: "assigned_by_user_id", optional: true

  enum :status, {
    assigned: "assigned",
    confirmed: "confirmed",
    declined: "declined",
    cancelled: "cancelled"
  }, validate: true

  validates :status, presence: true
  validates :employee_id, uniqueness: { scope: :shift_id, message: "已指派到此班次" }

  before_create :set_assigned_at

  private

  def set_assigned_at
    self.assigned_at ||= Time.current
  end
end
