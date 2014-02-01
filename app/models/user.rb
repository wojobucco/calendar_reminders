class User < ActiveRecord::Base
  has_many :appointments
  has_many :contacts

  validates :email, :name, presence: true
end
