class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :push_id
      t.integer :user_id
      t.integer :created_on
      t.integer :updated_on
      #t.timestamps null: false
    end
  end
end
