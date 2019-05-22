require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  test 'timsheet should save successfully' do
    timesheet = Timesheet.new(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'))
    assert timesheet.save, "Timesheet saved successfully"
  end

  test 'ensures date presence' do
    timesheet = Timesheet.new(start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet without date"
  end

  test 'ensures start_time presence' do
    timesheet = Timesheet.new(date: Time.new(2019, 4, 22), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet without start_time"
  end

  test 'ensures finish_time presence' do
    timesheet = Timesheet.new(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet without finish_time"
  end

  test 'ensures #valid_start_time' do
    timesheet = Timesheet.new(date: Time.new(2020, 4, 22), start_time: DateTime.new(2020, 4, 22, 10, 0, 0, '+10:00'), finish_time: DateTime.new(2020, 4, 22, 17, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet in the future"
  end

  test 'ensures #valid_finish_time' do
    timesheet = Timesheet.new(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet with start time laster than finish time"
  end

  #TODO: Implement testing for #no_overlap

  test 'ensures #no_same_time' do
    timesheet = Timesheet.new(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'))
    assert_not timesheet.save, "Saved timesheet with start time same as finish time"
  end

  #TODO: Implement testing for #calculate_rate
end

