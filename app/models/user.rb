require 'pry'

class User < ActiveRecord::Base
    has_secure_password

    def withdraw(amount)
        # TODO: check that amount is valid, else error
        @balance -= amount.to_d
        # TODO: check if sufficient funds available
    end

    def deposit(amount)
        # TODO: check that amount is valid, else error
        @balance += amount
    end
end
