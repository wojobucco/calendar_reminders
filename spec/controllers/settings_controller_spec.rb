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
      context "when the request format is html" do
        it "updates the setting with the received value in minutes" do
          setting = stub_model(Setting, key: :reminder_advance_time, value: "60", units: :minutes, user_id: 1)
          Setting.stub(:find).with('2').and_return(setting)

          setting.should_receive(:update_attributes).with(:value => '60', :units => :minutes)

          post :update, {id: 2, setting: {value: 60}, reminder_advance_time_units: :minutes},
            valid_session
        end

        it "updates the setting with the received value in hours" do
          setting = stub_model(Setting, key: :reminder_advance_time, value: "10", units: :hours, user_id: 1)
          Setting.stub(:find).with('2').and_return(setting)

          setting.should_receive(:update_attributes).with(:value => '10', :units => :hours)

          post :update, {id: 2, setting: {value: 10}, reminder_advance_time_units: :hours},
            valid_session
        end

        it "updates the setting with the received value in days" do
          setting = stub_model(Setting, key: :reminder_advance_time, value: "2", units: :days, user_id: 1)
          Setting.stub(:find).with('2').and_return(setting)

          setting.should_receive(:update_attributes).with(:value => '2', :units => :days)

          post :update, {id: 2, setting: {value: 2}, reminder_advance_time_units: :days},
            valid_session
        end

        it "returns a 400 error if the setting was not saved" do
          setting = stub_model(Setting, key: :reminder_advance_time, value: "2", units: :days, user_id: 1)
          Setting.stub(:find).with('2').and_return(setting)

          setting.should_receive(:update_attributes).with(:value => '2', :units => :days).and_return(false)

          post :update, {id: 2, setting: {value: 2}, reminder_advance_time_units: :days},
            valid_session

          expect(response.status).to eq(400)
        end
      end

      context "when the request format is json" do
        it "returns a 400 error if the setting was not saved" do
          setting = stub_model(Setting, key: :reminder_advance_time, value: "2", units: :days, user_id: 1)
          Setting.stub(:find).with('2').and_return(setting)

          setting.should_receive(:update_attributes).with(:value => '2', :units => :days).and_return(false)

          post :update, {format: :json, id: 2, setting: {value: '2'}, reminder_advance_time_units: :days},
            valid_session

          expect(response.status).to eq(400)
        end
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
