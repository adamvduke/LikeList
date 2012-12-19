require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do

    before(:each) do
      User.any_instance.stub(:update_likes).and_return(true)
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :show, id: @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, id: @user
      assigns(:user).should == @user
    end
  end

  describe "GET 'edit'" do
    it "returns http success"
  end

end
