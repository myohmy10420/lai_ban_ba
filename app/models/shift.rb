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

  has_many :shift_assignments, dependent: :destroy
  has_many :employees, through: :shift_assignments

  enum :role_tag, { floor: "floor", kitchen: "kitchen", cashier: "cashier" }, validate: true
  enum :source, { manual: "manual", auto: "auto", template: "template" }, validate: true

  validates :starts_at, :ends_at, presence: true
  validates :required_headcount, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :role_tag, presence: true
  validate :ends_after_starts

  scope :upcoming, -> { where("starts_at > ?", Time.current).order(:starts_at) }
  scope :for_date, ->(date) { where(starts_at: date.all_day) }

  def duration_hours
    return 0 unless starts_at && ends_at
    ((ends_at - starts_at) / 3600.0).round(1)
  end

  def fully_staffed?
    shift_assignments.where(status: %w[assigned confirmed]).count >= required_headcount
  end

  private

  def ends_after_starts
    return unless starts_at && ends_at
    errors.add(:ends_at, "必須晚於開始時間") if ends_at <= starts_at
  end
end
