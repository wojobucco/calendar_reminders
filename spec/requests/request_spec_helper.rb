module RequestSpecHelper
  def login
    client = double(GoogleApi, :authorization_uri => 'sessions/authorize',
      :refresh_token => 'fooey').as_null_object

    data = double('info', name: 'foo', email: 'foo@foo.com', id: '234234')
    result = double('result')
    result.stub(:data).and_return(data)
    client.stub(:get_user_info).and_return(result)
    client.stub(:access_token).and_return('lkjasdlkfjljasdlkfj_token')
    GoogleApi.stub(:new).and_return(client)

    users = double('beta_users')
    users.stub(:include?).and_return(true)
    SessionsController.class_variable_set(:@@beta_users, users)

    get sessions_authorize_path, code: 'foo'
  end
end
