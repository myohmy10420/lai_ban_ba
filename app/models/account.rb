# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Account < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :locations, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :shifts, dependent: :destroy
  has_many :shift_assignments, dependent: :destroy

  validates :name, presence: true
end
