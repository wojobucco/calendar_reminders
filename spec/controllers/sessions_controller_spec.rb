require 'spec_helper'

describe SessionsController do

  describe "POST authorize" do
    let(:api_result) { double('result') }

    before(:each) do
      APP_CONFIG['beta_users'] = 'foo@gmail.com, peep@poop.com'

      client = double('googleapi')
      client.stub(:get_user_info).and_return(api_result)
      client.stub(:refresh_token).and_return('token!')
      client.stub(:access_token).and_return('token!')

      GoogleApi.stub(:new).and_return(client)

      api_result.stub_chain(:data, :id).and_return('09324098820934')
      api_result.stub_chain(:data, :name).and_return('foo')
    end

    context "when the email is not in the beta users list" do

      before(:each) do
        api_result.stub_chain(:data, :email).and_return('poo@gmail.com')
      end

      context "when beta_mode_enabled is false" do
        before(:each) do
          stub_const("GlobalSetting::BETA_MODE_ENABLED", false)
        end

        it "should redirect to appointments" do
          post :authorize, { code: 'foo' }
          expect(response).to redirect_to(appointments_path)
        end
      end

      context "when beta_mode_enabled is true" do
        before(:each) do
          stub_const("GlobalSetting::BETA_MODE_ENABLED", true)
        end

        it "should not create a user" do
          User.should_not_receive(:find_or_create_by)
          post :authorize, { code: 'foo' }
        end

        it "should redirect to info/beta_notice" do
          post :authorize, { code: 'foo' }
          expect(response).to redirect_to(info_beta_notice_path)
        end
      end
    end

  end
end
