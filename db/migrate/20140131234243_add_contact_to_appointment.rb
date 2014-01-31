class AddContactToAppointment < ActiveRecord::Migration
  def change
    add_reference :appointments, :contacts
  end
end
