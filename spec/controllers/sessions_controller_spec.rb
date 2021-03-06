require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do

    it "should be a redirect" do
      get :new
      response.status.should eq(302)
    end

    it "should redirect to /auth/instagram" do
      get :new
      response.location.include?("/auth/instagram").should be_true
    end
  end

  describe "GET 'create'" do

    describe 'a valid sign in' do

      before do
        @omniauth_hash = JSON.parse(fixture("auth.json"))
        OmniAuth.config.test_mode = true
        OmniAuth.config.mock_auth[:instagram] = OmniAuth::AuthHash.new(@omniauth_hash)
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:instagram]
      end

      context 'with a new user' do

        it "should create a new user" do
          lambda {
            get :create, provider:"instagram"
          }.should change(User, :count).by(1)
        end

        it "should sign the user in" do
          get :create, provider:"instagram"
          controller.current_user.uid.should eq(@omniauth_hash['uid'])
          controller.should be_signed_in
        end

        it "should redirect to user#edit" do
          get :create, provider:"instagram"
          user = User.find(session[:user_id])
          response.should redirect_to(edit_user_path(user))
        end
      end

      context 'with an existing user' do
        before do
          @user = User.create_with_omniauth(@omniauth_hash)
        end

        it "should not create a new user" do
          lambda {
            get :create, provider:"instagram"
          }.should change(User, :count).by(0)
        end

        it "should sign the user in" do
          get :create, provider:"instagram"
          controller.current_user.uid.should eq(@omniauth_hash['uid'])
          controller.should be_signed_in
        end

        it "should update the user's last sign in" do
          @user.update_attribute(:last_sign_in, nil)
          get :create, provider:"instagram"
          @user.reload
          @user.last_sign_in.should_not be_nil
        end

        it "should update the user's token" do
          @user.update_attribute(:token, nil)
          get :create, provider:"instagram"
          @user.reload
          @user.token.should_not be_nil
        end
      end
    end
  end

  describe "DELETE 'destroy" do

    before do
      user = FactoryGirl.create(:user)
      session[:user_id] = user.id
    end

    it "should sign the user out" do
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
