class AddColumnToUsers < ActiveRecord::Migration[4.2]
    def change 
        add_column :users, :balance, :float, :default => 0.00
    end 
end 
