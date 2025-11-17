class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :downcase_email

  validates :email, uniqueness: { case_sensitive: false }

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
