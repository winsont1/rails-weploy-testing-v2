class Timesheet < ApplicationRecord
  validates :date, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate :valid_start_time, on: :create
  validate :valid_finish_time, on: :create
  validate :no_overlap, on: :create

  private

  def valid_start_time
    if start_time > DateTime.current
      errors.add(:start_time, "cannot be in the future")
    end
  end

  def valid_finish_time
    if start_time > finish_time
      errors.add(:start_time, "cannot be later than finish time")
    end
  end

  def no_overlap
    timesheets = Timesheet.all

    timesheets.each do |timesheet|
      if (start_time..finish_time).cover? timesheet.start_time
        errors.add(:start_time, "is overlapping with other timesheets")
      elsif (start_time..finish_time).cover? timesheet.finish_time
        errors.add(:finsh_time, "is overlapping with other timesheets")
      end
    end
  end
end
