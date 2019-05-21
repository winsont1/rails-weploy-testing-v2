require 'test_helper'

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  test "visiting the index" do
    visit "/"
    assert_selector "h1", text: "Timesheet Entries"
  end
end


