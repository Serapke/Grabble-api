class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :auth_token
      t.integer :score
      t.integer :place

      t.timestamps
    end
  end
end
