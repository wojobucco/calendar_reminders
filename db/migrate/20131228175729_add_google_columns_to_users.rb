class AddGoogleColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_id, :string
    add_column :users, :name, :string
  end
end
