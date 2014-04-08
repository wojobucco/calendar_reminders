class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :appointment, dependent: :destroy

  scope :undeleted, -> { where(deleted: false) }

  def delete
    self.update_attributes(:deleted => true)

    Appointment.where(contact_id: self.id).each { |appt| appt.delete }
  end
end
