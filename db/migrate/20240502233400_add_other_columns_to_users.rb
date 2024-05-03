class AddOtherColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, unique: true, null: false
    add_column :users, :email, :string
    add_column :users, :phone, :string
  end
end
