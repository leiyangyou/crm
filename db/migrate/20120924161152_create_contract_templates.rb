class CreateContractTemplates < ActiveRecord::Migration
  def change
    create_table :contract_templates do |t|
      t.references :contract_type
      t.text :template
      t.text :parameters

      t.timestamps
    end
    add_index :contract_templates, :contract_type_id
  end
end
