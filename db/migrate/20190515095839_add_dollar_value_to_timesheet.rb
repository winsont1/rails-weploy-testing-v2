class AddDollarValueToTimesheet < ActiveRecord::Migration[5.2]
  def change
    add_column :timesheets, :dollar_value, :float
  end
end
