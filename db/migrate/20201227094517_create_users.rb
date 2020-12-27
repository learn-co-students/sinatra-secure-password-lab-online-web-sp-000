class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    unless ActiveRecord::Base.connection.table_exists?('users')
      create_table :users do |t|
          t.string :username
          t.float :balance, default: 0.0
          t.string :password_digest
        end
      end
  end
end
