class Createusers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |x|
      x.string :username
      x.string :password_digest
    end
  end

  def down
    drop_table :users
  end
end
