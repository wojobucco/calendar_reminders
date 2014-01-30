class ContactsController < ApplicationController
  before_filter :authorize

  def index
    Contact.service = GoogleApi.new(session[:access_token])
    @contacts = Contact.find_all
    render text: @contacts.inspect
  end
end
