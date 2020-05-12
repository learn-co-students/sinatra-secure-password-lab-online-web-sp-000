class User < ActiveRecord::Base
    has_secure_password

    def desposit(amount)
        self.balance += amount.to_i
    end

    def withdraw(amount)
        if amount.to_i > self.balance
            false
        else
            self.balance -= amount.to_i
            true
        end
    end
end
