class LocationBusinessHour < ApplicationRecord
  belongs_to :location, inverse_of: :business_hours

  DAYS = %w[週日 週一 週二 週三 週四 週五 週六].freeze

  validates :day_of_week, presence: true,
            inclusion: { in: 0..6 },
            uniqueness: { scope: :location_id }
  validates :opens_at, :closes_at, presence: true, unless: :is_closed?
  validate :closes_after_opens, unless: :is_closed?

  def day_name
    DAYS[day_of_week]
  end

  private

  def closes_after_opens
    return unless opens_at && closes_at
    errors.add(:closes_at, "必須晚於開始時間") if closes_at <= opens_at
  end
end
