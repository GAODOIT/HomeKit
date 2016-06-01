class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :node_mac
      t.integer :created_on
      t.integer :updated_on
      #t.timestamps null: false
    end
  end
end
