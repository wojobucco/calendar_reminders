require 'spec_helper'

describe SettingsController do

  context "with an authenticated user" do
    let(:valid_session) { {user_id: 1} }

    before(:each) do
      User.create!(id: 1, name: "foo", email: "foo@foo.com")
    end

    describe "GET index" do

      it "should assign the settings variable" do
        settings = [stub_model(Setting, id: 1, user_id: 1)]
        Setting.stub(:where).with(user_id: 1).and_return(settings)

        get :index, {}, valid_session

        expect(assigns(:settings)).to eq(settings)
      end

      it "should render the index view" do
        get :index, {}, valid_session
        expect(response).to render_template("index")
      end

    end

    describe "PUT update" do
      it "updates the setting with the received value" do
        Setting.should_receive(:update).with('2', value: 60).and_return(stub_model(Setting, persisted: true))

        post :update, {id: 2, setting: {value: 60}, time_units: :minutes},
          valid_session
      end
    end

  end

  context "without an authenticated user" do

    describe "GET index" do

      it "should redirect the user to the root" do
        get :index
        expect(response).to redirect_to(root_path)
      end

    end

  end
end
