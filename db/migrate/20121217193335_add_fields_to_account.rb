class AddFieldsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :trainer_id, :integer
    add_column :accounts, :gender, :integer
    add_column :accounts, :nationality, :string
    add_column :accounts, :identification, :string
    add_column :accounts, :dob, :date
    add_column :accounts, :work_phone, :string
    add_column :accounts, :emergency_contact_1, :string
    add_column :accounts, :emergency_contact_2, :string
    add_column :accounts, :card_number, :string
    add_column :accounts, :company, :string

    add_index :accounts, :card_number
    add_index :accounts, :trainer_id
  end
end
