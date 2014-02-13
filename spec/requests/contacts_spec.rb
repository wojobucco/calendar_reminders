require 'spec_helper'

describe "Contacts" do
  describe "GET /contacts" do

    context "with an authenticated user" do

      before(:each) do
        client = double(GoogleApi, :authorization_uri => sessions_authorize_path,
          :refresh_token => 'fooey').as_null_object

        data = double('info', name: 'foo', email: 'foo@foo.com', id: '234234')
        result = double('result')
        result.stub(:data).and_return(data)
        client.stub(:get_user_info).and_return(result)
        GoogleApi.stub(:new).and_return(client)

        get sessions_authorize_path, code: 'foo'
      end

      it "displays index successfully" do
        # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
        get contacts_path
        response.status.should be(200)
      end

    end
  end
end
