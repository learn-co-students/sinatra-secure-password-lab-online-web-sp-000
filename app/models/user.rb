class User < ActiveRecord::Base
    has_secure_password
    after_initialize :init

    def init
      self.balance ||= 0.00          
    end

    def withdrawal(amount)
        # if self.balance - amount < 0.0
        #   puts "only able to withdraw #{self.balance}"
        # else
        #   self.balance -= amount
        # end
        self.balance -= amount
    end

    def deposit(amount)
        self.balance += amount
    end
    
end
