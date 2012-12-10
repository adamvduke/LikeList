require 'spec_helper'

describe User do
  describe 'Creating a new user' do

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

  describe 'Deleting an existing user' do

    before do
      User.any_instance.stubs(:update_likes).returns(true)
      @user = FactoryGirl.create(:user)
    end

    it 'should delete the user' do
      lambda {
        @user.destroy
      }.should change(User, :count).by(-1)
    end

    context 'with likes' do

      before do
        5.times do
          FactoryGirl.create(:like, user:@user)
        end
      end

      it 'should delete the dependent likes' do
        lambda {
          @user.destroy
        }.should change(Like, :count).by(-5)
      end
    end
  end
end
