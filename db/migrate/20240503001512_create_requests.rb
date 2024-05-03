class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.string :number
      t.text :description
      t.integer :state, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
