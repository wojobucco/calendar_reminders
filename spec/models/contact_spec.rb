require 'spec_helper'

describe Contact do
  describe "#delete" do
    it "does a soft delete of the contact by setting deleted => true" do
      contact = Contact.create(name: 'foo', phone_number: '111-222-3322', user_id: 1, deleted: false)

      expect(contact.deleted).to be_false

      contact.delete
      
      expect(contact.deleted).to be_true
    end
  end
end
