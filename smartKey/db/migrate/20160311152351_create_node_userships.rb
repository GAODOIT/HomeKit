class CreateNodeUserships < ActiveRecord::Migration
  def change
    create_table :node_userships do |t|
      t.integer :node_id
      t.integer :user_id
      t.integer :created_on
      t.integer :updated_on
      #t.timestamps null: false
    end
  end
end
