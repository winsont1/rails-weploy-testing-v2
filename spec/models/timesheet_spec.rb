require 'rails_helper'

RSpec.describe Timesheet, type: :model do
  context 'validation tests' do
    it 'should save successfully' do
      timesheet = Timesheet.create(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00'))
      expect(timesheet).to be_valid
    end
    it 'ensures date presence' do
      timesheet = Timesheet.new(start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00'), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00')).save
      expect(timesheet).to eq(false)
    end
    it 'ensures start_time presence' do
      timesheet = Timesheet.new(date: Time.new(2019, 4, 22), finish_time: DateTime.new(2019, 4, 22, 17, 0, 0, '+10:00')).save
      expect(timesheet).to eq(false)
    end
    it 'ensures finish_time presence' do
      timesheet = Timesheet.new(date: Time.new(2019, 4, 22), start_time: DateTime.new(2019, 4, 22, 10, 0, 0, '+10:00')).save
      expect(timesheet).to eq(false)
    end
  end
  context 'scope tests' do
  end
end
