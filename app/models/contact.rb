class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :appointment, dependent: :destroy
end
