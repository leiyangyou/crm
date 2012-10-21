class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.string :contract_id
      t.references :contract_template
      t.text :content
      t.text :parameters
      t.string :state
      t.timestamp :started_at
      t.timestamp :end_at
      t.timestamp :signed_at

      t.timestamps
    end
    add_index :contracts, :contract_template_id
    add_index :contracts, :contract_id, :unique => true
  end
end
