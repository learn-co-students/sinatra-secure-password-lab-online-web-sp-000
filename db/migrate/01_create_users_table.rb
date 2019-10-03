# # class CreateUsersTable < ActiveRecord::Migration[5.0]
# #   def change
# #     create_table :users do |t|
# #       t.string :username
# #       t.string :password
# #     end
# #   end
# # end
#
# class CreateUsersTable < ActiveRecord::Migration[5.0]
#   def change
#     create_table :users do |t|
#       t.string :username
#       t.string :password_digest
#     end
#   end
# end

class CreateUsersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end
  end
end
