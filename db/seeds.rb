require 'pry'
Timesheet.destroy_all

puts "Creating 10 Fake Timesheets!"



Timesheet.create(date: Time.new(2019,4,15), start_time: DateTime.new(2019,4,15,10,0,0,'+10:00'), finish_time: DateTime.new(2019,4,15,17,0,0,'+10:00'))
Timesheet.create(date: Time.new(2019,4,16), start_time: DateTime.new(2019,4,16,12,0,0,'+10:00'), finish_time: DateTime.new(2019,4,16,20,15,0,'+10:00'))
Timesheet.create(date: Time.new(2019,4,17), start_time: DateTime.new(2019,4,17,4,0,0,'+10:00'), finish_time: DateTime.new(2019,4,17,21,30,0,'+10:00'))
Timesheet.create(date: Time.new(2019,4,20), start_time: DateTime.new(2019,4,20,15,30,0,'+10:00'), finish_time: DateTime.new(2019,4,20,20,0,0,'+10:00'))
Timesheet.create(date: Time.new(2019,4,22), start_time: DateTime.new(2019,4,22,10,0,0,'+10:00'), finish_time: DateTime.new(2019,4,22,17,0,0,'+10:00'))
