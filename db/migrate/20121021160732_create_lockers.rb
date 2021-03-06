class CreateLockers < ActiveRecord::Migration
  def change
    create_table :lockers do |t|
      t.string :identifier
      t.string :status
      t.timestamps
    end
    add_index :lockers, :identifier, :unique => true
  end
end
