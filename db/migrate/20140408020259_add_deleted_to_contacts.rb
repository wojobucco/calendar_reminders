class AddDeletedToContacts < ActiveRecord::Migration
  class Contact < ActiveRecord::Base
  end

  def change
    add_column :contacts, :deleted, :boolean, :default => false

    Contact.reset_column_information

    reversible do |dir|
      dir.up { Contact.update_all(deleted: false) }
    end
  end
end
