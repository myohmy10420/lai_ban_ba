# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string           not null
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships
  has_many :employees, dependent: :nullify

  before_validation :downcase_email

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validate :password_complexity, if: -> { password.present? }

  private

  def password_complexity
    return if password =~ /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/

    errors.add(:password, "需包含英文大寫、小寫及數字")
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
