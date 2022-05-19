class CreateUsers < ActiveRecord::Migration[7.0]
  def self.up
    create_table :users  do |t|
      t.string :email, null: false
      t.string :crypted_password, null: false
      t.string :password_salt, null: false
      t.string :persistence_token, null: false
      t.timestamps
    end

    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
