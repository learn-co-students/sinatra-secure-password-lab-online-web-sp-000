class Createusers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |u|
      u.string :username
      u.string :password_digest
      u.float :balance
    end
  end
end
