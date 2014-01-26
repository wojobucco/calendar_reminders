class User < ActiveRecord::Base
  validates :email, :name, presence: true
end
