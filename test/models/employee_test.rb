# == Schema Information
#
# Table name: employees
#
#  id          :bigint           not null, primary key
#  end_on      :date
#  name        :string
#  phone       :string
#  start_on    :date
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#  location_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_employees_on_account_id   (account_id)
#  index_employees_on_location_id  (location_id)
#  index_employees_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
