class ContactsController < ApplicationController
  before_action :authorize
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.undeleted.where(user_id: current_user.id)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @contact.save
        format.html { redirect_to contacts_url, notice: 'Contact was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params.merge(user_id: current_user.id))
        format.html { redirect_to contacts_url, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.delete
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  def destroy_selected
    selected_contacts.each do |id|
      contact = Contact.find(id)
      contact.delete
    end

    flash[:success] = "Contact(s) deleted" unless selected_contacts.empty?
    redirect_to contacts_url
  end

  private

  def selected_contacts
    contacts = []
    params.each_key do |key|
      if (key =~ /selected_contact_id_(\d+)/)
        contacts << $1
      end
    end

    return contacts
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :phone_number)
  end
end
