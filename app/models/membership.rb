# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_memberships_on_account_id  (account_id)
#  index_memberships_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :user

  ROLES = %w[owner manager staff].freeze
  ROLE_I18N = { "owner" => "擁有者", "manager" => "店長", "staff" => "員工" }.freeze

  enum :role, { owner: "owner", manager: "manager", staff: "staff" }, validate: true

  validates :role, presence: true
  validates :user_id, uniqueness: { scope: :account_id, message: "已是此帳號成員" }

  def role_i18n
    ROLE_I18N[role] || role
  end
end
