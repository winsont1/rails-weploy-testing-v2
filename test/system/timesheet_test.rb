require "application_system_test_case"


class TimesheetTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit "/"
    assert_selector "h1", text: "Timesheet Entries"
    assert_selector ".timesheet-body", count: Timesheet.count
  end

  test "lets a user log a new timesheet" do
    visit "/timesheets/new"
    # save_and_open_screenshot
    select_date("2015,May,10", :from => "Date")
    select_time("10","00", :from => "Start Time")
    select_time("17","00", :from => "Finish Time")
    # save_and_open_screenshot

    click_on 'Create'
    # save_and_open_screenshot

    # Should be redirected to Home with new timesheet
    assert_equal root_path, page.current_path
    assert_text "Timesheet Entries"
  end

  test "prevent user from creating a timesheet with the same start and finish time" do
    visit "/timesheets/new"
    timesheet_count_before = Timesheet.count

    # save_and_open_screenshot
    select_date("2015,May,10", :from => "Date")
    select_time("10","00", :from => "Start Time")
    select_time("10","00", :from => "Finish Time")
    # save_and_open_screenshot

    click_on 'Create'
    # save_and_open_screenshot

    # Should be redirected to Home with new timesheet
    assert_equal "/timesheets", page.current_path
    assert_equal timesheet_count_before, Timesheet.count
  end

  test "prevent user from creating a timesheet with start time later than finish time" do
    visit "/timesheets/new"
    timesheet_count_before = Timesheet.count

    # save_and_open_screenshot
    select_date("2015,May,10", :from => "Date")
    select_time("17","00", :from => "Start Time")
    select_time("10","00", :from => "Finish Time")
    # save_and_open_screenshot

    click_on 'Create'
    save_and_open_screenshot

    # Should be redirected to Home with new timesheet
    assert_equal "/timesheets", page.current_path
    assert_equal timesheet_count_before, Timesheet.count
  end

  test "prevent user from creating a timesheet in the future" do
    visit "/timesheets/new"
    timesheet_count_before = Timesheet.count

    # save_and_open_screenshot
    select_date("2020,April,10", :from => "Date")
    select_time("10","00", :from => "Start Time")
    select_time("17","00", :from => "Finish Time")
    # save_and_open_screenshot

    click_on 'Create'
    save_and_open_screenshot

    # Should be redirected to Home with new timesheet
    assert_equal "/timesheets", page.current_path
    assert_equal timesheet_count_before, Timesheet.count
  end

  #TODO: Create test to prevent overlapping timesheets


  private

  def select_date(date, options = {})
    field = options[:from]
    base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
    year, month, day = date.split(',')
    select year,  :from => "#{base_id}_1i"
    select month, :from => "#{base_id}_2i"
    select day,   :from => "#{base_id}_3i"
  end

  def select_time(hour, minute, options = {})
    field = options[:from]
    base_id = find(:xpath, ".//label[contains(.,'#{field}')]")[:for]
    select hour, :from => "#{base_id}_4i"
    select minute, :from => "#{base_id}_5i"
  end

end


