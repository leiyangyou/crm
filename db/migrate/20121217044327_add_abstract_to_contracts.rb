class AddAbstractToContracts < ActiveRecord::Migration
  def change
    add_column :contracts, :abstract, :string
  end
end
