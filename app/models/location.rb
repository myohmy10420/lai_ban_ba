# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_locations_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Location < ApplicationRecord
  belongs_to :account

  has_many :employees, dependent: :nullify
  has_many :shifts, dependent: :destroy
  has_many :business_hours, -> { order(:day_of_week) }, class_name: "LocationBusinessHour",
           dependent: :destroy, inverse_of: :location
  accepts_nested_attributes_for :business_hours

  validates :name, presence: true
end
