class User < ActiveRecord::Base
    has_secure_password #includes method to authenticate password
end
