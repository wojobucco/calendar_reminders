class AddUserRelationToContacts < ActiveRecord::Migration
  def change
    add_reference :contacts, :user
  end
end
