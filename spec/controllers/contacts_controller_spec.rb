require 'spec_helper'

describe ContactsController do
  
  let(:valid_attributes) { { "name" => "MyString", user_id: 1 } }
  let(:valid_session) { {user_id: 1} }

  before(:each) do
    User.create!(id: 1, name: "foo", email: "foo@foo.com")
  end

  describe "GET index" do
    it "assigns all contacts as @contacts" do
      contact = Contact.create! valid_attributes
      get :index, {}, valid_session
      assigns(:contacts).should eq([contact])
    end

    it "only retrieves contacts for the currently logged in user" do
      contact = Contact.create! valid_attributes
      contact2 = Contact.create!({ name: "not my contact", user_id: 2 })

      get :index, {}, valid_session
      assigns(:contacts).should eq([contact])
    end
  end

  describe "GET new" do
    it "assigns a new contact as @contact" do
      get :new, {}, valid_session
      assigns(:contact).should be_a_new(Contact)
    end
  end

  describe "GET edit" do
    it "assigns the requested contact as @contact" do
      contact = Contact.create! valid_attributes
      get :edit, {:id => contact.id}, valid_session
      expect(assigns(:contact)).to eq(contact)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Contact" do
        expect {
          post :create, {:contact => valid_attributes}, valid_session
        }.to change(Contact, :count).by(1)
      end

      it "assigns a newly created contact as @contact" do
        post :create, {:contact => valid_attributes}, valid_session
        assigns(:contact).should be_a(Contact)
        assigns(:contact).should be_persisted
      end

      it "redirects to the created contact" do
        post :create, {:contact => valid_attributes}, valid_session
        response.should redirect_to(contacts_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contact as @contact" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contact.any_instance.stub(:save).and_return(false)
        post :create, {:contact => { "name" => "invalid value" }}, valid_session
        assigns(:contact).should be_a_new(Contact)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Contact.any_instance.stub(:save).and_return(false)
        post :create, {:contact => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contact" do
        contact = Contact.create! valid_attributes
        # Assuming there are no other contacts in the database, this
        # specifies that the Contact created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Contact.any_instance.should_receive(:update).with({ "name" => "MyString", "user_id" => 1 })
        put :update, {:id => contact.to_param, :contact => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested contact as @contact" do
        contact = Contact.create! valid_attributes
        put :update, {:id => contact.to_param, :contact => valid_attributes}, valid_session
        assigns(:contact).should eq(contact)
      end

      it "redirects to the contacts index" do
        contact = Contact.create! valid_attributes
        put :update, {:id => contact.to_param, :contact => valid_attributes}, valid_session
        response.should redirect_to(contacts_path)
      end
    end

    describe "with invalid params" do
      it "assigns the contact as @contact" do
        contact = Contact.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Contact.any_instance.stub(:save).and_return(false)
        put :update, {:id => contact.to_param, :contact => { "name" => "invalid value" }}, valid_session
        assigns(:contact).should eq(contact)
      end

      it "re-renders the 'edit' template" do
        contact = Contact.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Contact.any_instance.stub(:save).and_return(false)
        put :update, {:id => contact.to_param, :contact => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contact" do
      contact = Contact.create! valid_attributes
      expect {
        delete :destroy, {:id => contact.to_param}, valid_session
      }.to change(Contact, :count).by(-1)
    end

    it "redirects to the contacts list" do
      contact = Contact.create! valid_attributes
      delete :destroy, {:id => contact.to_param}, valid_session
      response.should redirect_to(contacts_url)
    end
  end

end
