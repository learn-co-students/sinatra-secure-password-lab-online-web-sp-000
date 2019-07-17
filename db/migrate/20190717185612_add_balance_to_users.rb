class AddBalanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :balance, :decimal, precision: 30, scale: 2, default: 0
  end
end
