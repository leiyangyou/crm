class AddFormatToContractTemplates< ActiveRecord::Migration
  def change
    add_column :contract_templates, :format, :string
  end
end
