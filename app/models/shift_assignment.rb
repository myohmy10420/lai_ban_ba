class ShiftAssignment < ApplicationRecord
  belongs_to :account
  belongs_to :shift
  belongs_to :employee
end
