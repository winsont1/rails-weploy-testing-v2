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
      finish_time: DateTime.new(date_set.year, date_set.month, date_set.day, params[:timesheet]['finish_time(4i)'].to_i, params[:timesheet]['finish_time(5i)'].to_i, 0, dst_adjustment)
      )

    if @timesheet.save
      redirect_to root_path, success: 'Timesheet was successfully created.'
    else
      flash[:danger] = "Invalid input. Please review errors below."
      render :new
    end
  end
end
