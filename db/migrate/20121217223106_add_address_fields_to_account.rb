class AddAddressFieldsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :street1, :string
    add_column :accounts, :street2, :string
    add_column :accounts, :zipcode, :string
  end
end
