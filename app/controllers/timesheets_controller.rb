class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    date_set = Date.new(params[:timesheet]['date(1i)'].to_i,params[:timesheet]['date(2i)'].to_i, params[:timesheet]['date(3i)'].to_i)

    @timesheet = Timesheet.new(
      date: date_set,
      start_time: DateTime.new(date_set.year, date_set.month, date_set.day, params[:timesheet]['start_time(4i)'].to_i, params[:timesheet]['start_time(5i)'].to_i, 0),
      finish_time: DateTime.new(date_set.year, date_set.month, date_set.day, params[:timesheet]['finish_time(4i)'].to_i, params[:timesheet]['finish_time(5i)'].to_i,0)
      )
    @timesheet.save
    redirect_to root_path
  end
end



