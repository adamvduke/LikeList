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

    it { should have_valid(:provider).when('instagram', 'github', 'facebook', 'twitter') }
    it { should_not have_valid(:provider).when('') }

    it { should have_valid(:uid).when('12345', 'abcdef') }
    it { should_not have_valid(:uid).when('') }

    it { should have_valid(:nickname).when('adamvduke', 'indiebrain', 'nerded') }
    it { should_not have_valid(:nickname).when('') }

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

      it "should set the user's token to nil on RestClient::BadRequest" do
        RestClient.stub(:get).and_raise(RestClient::BadRequest)
        user = FactoryGirl.create(:user, token: 'abc123')
        user.json_for('http://example.com')
        #user.reload
        user.token.should be_nil
      end
    end

    describe '#initial_liked_media_url' do
      context 'for a user with a vaild auth token' do
        it 'should return the correct url' do
          user = FactoryGirl.create(:user)
          user.initial_liked_media_url.should eq("https://api.instagram.com/v1/users/self/media/liked/?access_token=#{user.token}")
        end
      end

      context 'for a user with a nil auth token' do
        it 'should return the correct url' do
          user = FactoryGirl.create(:user, token: nil)
          user.initial_liked_media_url.should be_nil
        end
      end
    end

    describe '#liked_posts' do
      it "should find 20 posts" do
        user = FactoryGirl.create(:user)
        user.liked_posts.count.should eq(20)
      end

      it "should not throw an exception if json_for returns nil" do
        user = FactoryGirl.create(:user)
        user.stub(:json_for).and_return(nil)
        user.liked_posts.should eq([])
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
