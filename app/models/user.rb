class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :username, :password

  def make_deposit(amount)
    user_balance = self.balance
    new_balance = user_balance + amount
    self.update_attribute(:balance, new_balance)
  end

  def withdraw_money
    
  end
end
