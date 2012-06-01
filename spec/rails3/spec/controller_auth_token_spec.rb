require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ApplicationController do
  
  # ----------------- AUTH TOKEN ------------------
  describe ApplicationController, "with auth token features" do
    before(:all) do
      ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate/auth_token")
      sorcery_reload! [:auth_token]
      create_new_user username: 'user', email: 'user@example.com', password: 'secret', auth_token: 'abc'
    end
    
    after(:each) do
      logout_user
      ActiveRecord::Migrator.rollback("#{Rails.root}/db/migrate/auth_token")
    end
    
    it "authenticates with auth token if sent in params" do
      get :some_action, token: @user.auth_token
      response.should be_a_success
    end
    
    it "authenticates with auth token if sent in headers" do
      @request.env["TOKEN"] = @user.auth_token
      get :some_action
      response.should be_a_success
    end
    
    it "fails authentication if wrong token in params" do
      get :some_action, token: 'wrong'
      response.should_not be_a_success
    end
    
    it "fails authentication if wrong token in headers" do
      @request.env["TOKEN"] = 'wrong'
      get :some_action
      response.should_not be_a_success
    end
    
  end
end