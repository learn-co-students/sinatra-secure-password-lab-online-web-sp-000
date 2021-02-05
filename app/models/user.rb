class User < ActiveRecord::Base
   # attr_reader :username, :password

    has_secure_password
end
