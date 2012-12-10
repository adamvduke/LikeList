require 'spec_helper'

describe User do
  describe 'create_with_omniauth' do
    before do
      User.any_instance.stubs(:update_likes).returns(true)
      @auth = JSON.parse(fixture('auth.json'))
      @user = User.create_with_omniauth(@auth)
    end

    it "should return an instance of User" do
      @user.class.should eq(User)
    end

    it "should set the correct provider" do
      @user.provider.should eq("instagram")
    end

    it "should set the correct uid" do
      @user.uid.should eq("5524055")
    end

    it "should set the correct token" do
      @user.token.should eq("5424055.6143c7e.408210fd97254259aa1acc86047ee361")
    end

    it "should set the correct name" do
      @user.name.should eq("Adam Duke")
    end

    it "should set the correct nickname" do
      @user.nickname.should eq("adamvduke")
    end
  end
end
