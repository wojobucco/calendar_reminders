class ChangeAppointmentsDeletedDefault < ActiveRecord::Migration
  def change
    change_column_default :appointments, :deleted, false
  end
end
