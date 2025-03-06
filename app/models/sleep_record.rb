class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :clock_in, presence: true
  validate :clock_out_time

  before_save :set_duration

  def set_duration
    self.duration = clock_out ? (clock_out - clock_in).to_i : nil
  end

  private

  def clock_out_time
    return if clock_out.nil? || clock_out > clock_in

    errors.add(:clock_out, "must be after clock_in time")
  end
end
