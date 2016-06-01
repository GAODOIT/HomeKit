class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_num
      t.string :password
      t.integer :created_on
      t.integer :updated_on
      #t.timestamps null: false
    end
  end
end
