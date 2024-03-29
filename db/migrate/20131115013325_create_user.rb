class CreateUser < ActiveRecord::Migration
  def up
  	create_table :users do |t|
          t.string :fname
          t.string :lname
          t.string :username
          t.string :bio_info
          t.string :email
          t.string :city
          t.string :state
          t.datetime :created_at
          t.string :password_salt
          t.string :password_hash
  	end
  end

  def down
  	drop_table :users
  end
end
