require 'pry'
class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    date_set = Time.new(params[:timesheet]['date(1i)'].to_i, params[:timesheet]['date(2i)'].to_i, params[:timesheet]['date(3i)'].to_i)

    #Adjust for daylight savings
    if date_set.dst?
      dst_adjustment = '+11:00'
    else
      dst_adjustment = '+10:00'
    end

    @timesheet = Timesheet.new(
      date: date_set,
      start_time: DateTime.new(date_set.year, date_set.month, date_set.day, params[:timesheet]['start_time(4i)'].to_i, params[:timesheet]['start_time(5i)'].to_i, 0, dst_adjustment),
      finish_time: DateTime.new(date_set.year, date_set.month, date_set.day, params[:timesheet]['finish_time(4i)'].to_i, params[:timesheet]['finish_time(5i)'].to_i, 0, dst_adjustment),
      )
    @timesheet[:dollar_value] = calculate_rate(@timesheet.date, @timesheet.start_time, @timesheet.finish_time)

    if @timesheet.save
      redirect_to root_path, success: 'Timesheet was successfully created.'
    else
      flash[:danger] = "Invalid input. Please review errors below."
      render :new
    end
  end

  private

  def calculate_rate(date, start_time, finish_time)
    inside_starting_time = Time.new(date.year, date.month, date.day, 7, 0, 0)
    inside_ending_time = Time.new(date.year, date.month, date.day, 19, 0, 0)

    odd_days = ['Monday', 'Wednesday', 'Friday']
    even_days = ['Tuesday', 'Thursday']
    rates = { odd_inside: 22, odd_outside: 33, even_inside: 25, even_outside: 35 , weekend: 47 }


    if odd_days.include? date.strftime("%A")
      if start_time >= inside_starting_time && finish_time <= inside_ending_time
        return TimeDifference.between(start_time, finish_time).in_hours * rates[:odd_inside]

      elsif start_time < inside_starting_time && finish_time > inside_ending_time
        return both_outside_hours(start_time, finish_time, inside_starting_time, inside_ending_time, rates[:odd_inside], rates[:odd_outside])

      elsif start_time < inside_starting_time && finish_time < inside_ending_time
        return before_outside_hours(start_time, finish_time, inside_starting_time, rates[:odd_inside], rates[:odd_outside])

      elsif start_time > inside_starting_time && finish_time > inside_ending_time
        return after_outside_hours(start_time, finish_time, inside_ending_time, rates[:odd_inside], rates[:odd_outside])
      end

    elsif even_days.include? date.strftime("%A")
      if start_time >= inside_starting_time && finish_time <= inside_ending_time
        return TimeDifference.between(start_time, finish_time).in_hours * rates[:even_inside]

      elsif start_time < inside_starting_time && finish_time > inside_ending_time
        return both_outside_hours(start_time, finish_time, inside_starting_time, inside_ending_time, rates[:even_inside], rates[:even_outside])

      elsif start_time < inside_starting_time && finish_time < inside_ending_time
        return before_outside_hours(start_time, finish_time, inside_starting_time, rates[:even_inside], rates[:even_outside])

      elsif start_time > inside_starting_time && finish_time > inside_ending_time
        return after_outside_hours(start_time, finish_time, inside_ending_time, rates[:even_inside], rates[:even_outside])
      end

    else
      dollar_value = TimeDifference.between(start_time, finish_time).in_hours * rates[:weekend]
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
