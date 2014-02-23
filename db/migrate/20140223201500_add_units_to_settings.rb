class AddUnitsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :units, :integer
  end
end
