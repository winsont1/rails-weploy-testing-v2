Timesheet.destroy_all

puts "Creating 10 Fake Timesheets!"



Timesheet.new(date: Time.new(2018,7,1), start_time: DateTime.new(2018,7,1,10,15,0), finish_time: DateTime.new(2018,7,1,11,15,0)).save
Timesheet.new(date: Time.new(2019,4,1), start_time: DateTime.new(2019,4,1,10,15,0), finish_time: DateTime.new(2019,4,1,11,15,0)).save

