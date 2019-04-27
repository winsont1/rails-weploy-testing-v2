class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end

  def new
    @timesheet = Timesheet.new
  end

  def create
    date_set = [params[:timesheet]['date(1i)'].to_i,params[:timesheet]['date(2i)'].to_i, params[:timesheet]['date(3i)'].to_i]
    @timesheet = Timesheet.new(
      date: Date.new(date_set[0], date_set[1], date_set[2]),
      start_time: DateTime.new(date_set[0], date_set[1], date_set[2], params[:timesheet]['start_time(4i)'].to_i, params[:timesheet]['start_time(5i)'].to_i, 0, "+10:00"),
      finish_time: DateTime.new(date_set[0], date_set[1], date_set[2], params[:timesheet]['finish_time(4i)'].to_i, params[:timesheet]['finish_time(5i)'].to_i,0, "+10:00")
      )
    raise
    @timesheet.save
  end
end
