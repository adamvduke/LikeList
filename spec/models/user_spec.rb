require 'spec_helper'

describe User do
  describe 'Creating a new user' do

    describe 'create_with_omniauth' do

      before do
        User.any_instance.stub(:update_likes).and_return(true)
        @auth = JSON.parse(fixture('auth.json'))
        @user = User.create_with_omniauth(@auth)
      end

      it "should increment the number of users" do
        lambda {
          User.create_with_omniauth(@auth)
        }.should change(User, :count).by(1)
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

      it "should set the correct image" do
        @user.image.should eq("http://images.instagram.com/profiles/profile_5524055_75sq_1329287807.jpg")
      end

      it "should set the correct bio" do
        @user.bio.should eq("Dirtbikes, Code, Hardcore, & Metal")
      end

      it "should set the correct website" do
        @user.website.should eq("http://adamvduke.com")
      end
    end
  end

  describe 'required attributes' do

    it "should require a provider" do
      no_name_user = FactoryGirl.build(:user, provider:"")
      no_name_user.should_not be_valid
    end

    it "should require a uid" do
      no_name_user = FactoryGirl.build(:user, uid:"")
      no_name_user.should_not be_valid
    end

    it "should require a nickname" do
      no_name_user = FactoryGirl.build(:user, nickname:"")
      no_name_user.should_not be_valid
    end
  end

  describe 'Deleting an existing user' do

    before do
      User.any_instance.stub(:update_likes).and_return(true)
      @user = FactoryGirl.create(:user)
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

  describe 'Updating likes' do

    describe '#json_for' do
      it "should return a hash" do
        user = FactoryGirl.create(:user)
        result = user.json_for("https://api.instagram.com/v1/users/self/media/liked/?access_token=#{user.token}")
        result.class.should be(Hash)
      end
    end

    describe '#liked_posts' do
      it "should find 20 posts" do
        user = FactoryGirl.create(:user)
        user.liked_posts.count.should eq(20)
      end
    end

    context '#update_likes' do
      it "should increment the number of likes by 20" do
        user = FactoryGirl.build(:user)
        lambda {
          user.update_likes_without_delay
        }.should change(Like, :count).by(20)
      end

      it "should not add duplicate likes" do
        user = FactoryGirl.create(:user)
        lambda {
          user.update_likes
        }.should change(Like, :count).by(0)
      end
    end

  end
end
