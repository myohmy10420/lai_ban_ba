# == Schema Information
#
# Table name: shifts
#
#  id                 :bigint           not null, primary key
#  ends_at            :datetime
#  lock_version       :integer
#  required_headcount :integer
#  role_tag           :string
#  source             :string
#  starts_at          :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null
#  location_id        :bigint           not null
#
# Indexes
#
#  index_shifts_on_account_id   (account_id)
#  index_shifts_on_location_id  (location_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (location_id => locations.id)
#
class Shift < ApplicationRecord
  belongs_to :account
  belongs_to :location
end
