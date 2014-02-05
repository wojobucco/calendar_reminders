class AddContactToAppointment < ActiveRecord::Migration
  def change
    add_reference :appointments, :contact
  end
end
