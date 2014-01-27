class User < ActiveRecord::Base
  has_many :appointments

  validates :email, :name, presence: true
end
