require 'test_helper'

class TimesheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_url
    assert_response :success
  end

  test "should get new timesheet page" do
    get new_timesheet_url
    assert_response :success
  end

  #TODO: Implement #create test
end


