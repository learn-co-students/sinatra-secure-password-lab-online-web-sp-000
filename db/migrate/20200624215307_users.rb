class Users < ActiveRecord::Migration[5.1]
  create_table :users do |t|
    t.string :username
    t.string :password_digest
  end
end
