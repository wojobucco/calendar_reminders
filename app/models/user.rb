class User < ActiveRecord::Base
  has_many :appointments, dependent: :destroy
  has_many :contacts, dependent: :destroy

  validates :email, :name, presence: true
end
