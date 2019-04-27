class CreateTimesheets < ActiveRecord::Migration[5.2]
  def change
    create_table :timesheets do |t|
      t.date :date
      t.datetime :start_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
