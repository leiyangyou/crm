class AddTypeIdToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :type_id, :integer
    add_index :contracts, :type_id
  end
end
