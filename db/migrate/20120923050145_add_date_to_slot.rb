class AddDateToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :date, :date
  end
end
