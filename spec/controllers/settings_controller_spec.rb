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
