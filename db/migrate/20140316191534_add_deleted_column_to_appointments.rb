# NOTE: this technique is the safest way to do a migration in which we are
# also migrating data.  we created a local model instead of using the one defined
# in the application, so as to not have to worry about any data validations for
# columns that do not yet exist in the database.

class AddDeletedColumnToAppointments < ActiveRecord::Migration
  class Appointment < ActiveRecord::Base
  end

  def change
    add_column :appointments, :deleted, :boolean

    Appointment.reset_column_information

    reversible do |dir|
      dir.up { Appointment.update_all(deleted: false) }
    end
  end
end
