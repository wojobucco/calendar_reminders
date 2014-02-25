class CreateReminderHistoryEntries < ActiveRecord::Migration
  def change
    create_table :reminder_history_entries do |t|
      t.references :appointment
      t.timestamps
    end
  end
end
