class AddUrlToContractType < ActiveRecord::Migration
  def change
    add_column :contract_types, :url, :string
  end
end
