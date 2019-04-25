class Timesheet < ApplicationRecord
  validates :date, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
end
