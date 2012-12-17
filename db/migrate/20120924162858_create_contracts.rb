class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :contract_id
      t.string :type
      t.references :contract_template
      t.references :account
      t.text :content
      t.text :parameters
      t.string :status
      t.date :started_on
      t.date :finished_on
      t.timestamp :signed_at

      t.timestamps
    end
    add_index :contracts, :contract_template_id
    add_index :contracts, :contract_id, :unique => true
    add_index :contracts, :type
  end
end
