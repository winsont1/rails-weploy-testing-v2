require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  context 'validation tests' do
    it 'ensures date presence' do
      timesheet = Timesheet.new(start_time: "10:00", finish_time: "10:00").save
      expect(timesheet).to eq(false)
    end
    it 'ensures start time' do
      timesheet = Timesheet.new(date: "07/01/2019", finish_time: "10:00").save
      expect(timesheet).to eq(false)
    end
    it 'ensures finish time' do
      timesheet = Timesheet.new(date: "07/01/2019", start_time: "10:00").save
      expect(timesheet).to eq(false)
    end
    it 'should save successfully' do
      timesheet = Timesheet.new(date: "07/01/2019", start_time: "10:00", finish_time: "10:00").save
      expect(timesheet).to eq(true)
    end
  end
  context 'scope tests' do
  end
end
