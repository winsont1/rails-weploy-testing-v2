class Timesheet < ApplicationRecord
  validates :date, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validate :valid_start_time, on: :create
  validate :valid_finish_time, on: :create
  validate :no_overlap, on: :create
  validate :no_same_time, on: :create
  before_save :calculate_rate

  private

  def valid_start_time
    unless start_time.nil?
      if start_time > DateTime.current
        errors.add(:start_time, "cannot be in the future")
      end
    end
  end

  def valid_finish_time
    unless start_time.nil? || finish_time.nil?
      if start_time > finish_time
        errors.add(:start_time, "cannot be later than finish time")
      end
    end
  end

  def no_overlap
    timesheets = Timesheet.all

    timesheets.each do |timesheet|
      if (start_time..finish_time).cover? timesheet.start_time
        errors.add(:start_time, "is overlapping with other timesheets")
      elsif (start_time..finish_time).cover? timesheet.finish_time
        errors.add(:finish_time, "is overlapping with other timesheets")
      end
    end
  end

  def no_same_time
    if start_time == finish_time
      errors.add(:start_time, "cannot equal finish time")
    end
  end

  def calculate_rate
    date = self.date
    start_time = self.start_time
    finish_time = self.finish_time
    inside_starting_time = Time.new(date.year, date.month, date.day, 7, 0, 0)
    inside_ending_time = Time.new(date.year, date.month, date.day, 19, 0, 0)

    odd_days = ['Monday', 'Wednesday', 'Friday']
    even_days = ['Tuesday', 'Thursday']
    rates = { odd_inside: 22, odd_outside: 33, even_inside: 25, even_outside: 35 , weekend: 47 }

    if odd_days.include? date.strftime("%A")
      if start_time >= inside_starting_time && finish_time <= inside_ending_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:odd_inside]
      elsif start_time < inside_starting_time && finish_time < inside_starting_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:odd_outside]
      elsif start_time < inside_starting_time && finish_time > inside_ending_time
        self.dollar_value = both_outside_hours(start_time, finish_time, inside_starting_time, inside_ending_time, rates[:odd_inside], rates[:odd_outside])
      elsif start_time < inside_starting_time && finish_time < inside_ending_time
        self.dollar_value = before_outside_hours(start_time, finish_time, inside_starting_time, rates[:odd_inside], rates[:odd_outside])
      elsif start_time > inside_ending_time && finish_time > inside_ending_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:odd_outside]
      elsif start_time > inside_starting_time && finish_time > inside_ending_time
        self.dollar_value = after_outside_hours(start_time, finish_time, inside_ending_time, rates[:odd_inside], rates[:odd_outside])
      else
        self.dollar_value = 0
      end

    elsif even_days.include? date.strftime("%A")
      if start_time >= inside_starting_time && finish_time <= inside_ending_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:even_inside]
      elsif start_time < inside_starting_time && finish_time < inside_starting_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:even_outside]
      elsif start_time < inside_starting_time && finish_time > inside_ending_time
        self.dollar_value = both_outside_hours(start_time, finish_time, inside_starting_time, inside_ending_time, rates[:even_inside], rates[:even_outside])
      elsif start_time < inside_starting_time && finish_time < inside_ending_time
        self.dollar_value = before_outside_hours(start_time, finish_time, inside_starting_time, rates[:even_inside], rates[:even_outside])
      elsif start_time > inside_ending_time && finish_time > inside_ending_time
        self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:even_outside]
      elsif start_time > inside_starting_time && finish_time > inside_ending_time
        self.dollar_value = after_outside_hours(start_time, finish_time, inside_ending_time, rates[:even_inside], rates[:even_outside])
      end

    else
      self.dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:weekend]
    end
  end


  def both_outside_hours(start_time, finish_time, inside_starting_time, inside_ending_time, inside_rate, outside_rate)
    before_value = TimeDifference.between(start_time, inside_starting_time).in_hours * outside_rate
    inside_value = TimeDifference.between(inside_starting_time, inside_ending_time).in_hours * inside_rate
    after_value = TimeDifference.between(inside_ending_time, finish_time).in_hours * outside_rate
    return before_value + inside_value + after_value
  end

  def before_outside_hours(start_time, finish_time, inside_starting_time, inside_rate, outside_rate)
    before_value = TimeDifference.between(start_time, inside_starting_time).in_hours * outside_rate
    inside_value = TimeDifference.between(inside_starting_time, finish_time).in_hours * inside_rate
    return before_value + inside_value
  end

  def after_outside_hours(start_time, finish_time, inside_ending_time, inside_rate, outside_rate)
    inside_value = TimeDifference.between(start_time, inside_ending_time).in_hours * inside_rate
    after_value = TimeDifference.between(inside_ending_time, finish_time).in_hours * outside_rate
    return inside_value + after_value
  end
end
