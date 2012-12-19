require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do

    context 'when not logged in' do
      it "should redirect to the root" do
        get :index
        response.should redirect_to(root_path)
      end
    end

    context 'when logged in' do
      context 'with an admin user' do

        before do
          User.any_instance.stub(:update_likes).and_return(true)
          @user = FactoryGirl.create(:user)
          @user.add_role :admin
          test_sign_in(@user)
        end

        it "should be successful" do
          get :index
          response.should be_success
        end

        it "should get a list of users" do
          get :index
          assigns(:users).should eq(User.all)
        end
      end
      context 'with a non admin user' do

        before do
          User.any_instance.stub(:update_likes).and_return(true)
          @user = FactoryGirl.create(:user)
          test_sign_in(@user)
        end

        it "should redirect to the root path" do
          get :index
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe "GET 'show'" do

    before do
      User.any_instance.stub(:update_likes).and_return(true)
      @user = FactoryGirl.create(:user)
      10.times do
        @user.likes << FactoryGirl.create(:like)
      end
    end

    it "should be successful" do
      get :show, id:@user
      response.should be_success
    end

    it "should find the right user" do
      get :show, id:@user
      assigns(:user).should eq(@user)
    end

    it "should assign the user's likes"

  end

  describe "GET 'edit'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, id: @user
      response.should be_success
    end

    it "should assign the correct user" do
      get :edit, id:@user
      assigns(:user).should eq(@user)
    end
  end

  describe "PUT 'update'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { email:"" }
      end

      it "should render the 'edit' page" do
        put :update, id:@user, user:@attr
        response.should render_template('edit')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { email:"user@example.org" }
      end

      it "should change the user's attributes" do
        put :update, id:@user, user:@attr
        @user.reload
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, id:@user, user:@attr
        response.should redirect_to(user_path(@user))
      end
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, id:@user
        response.should redirect_to(root_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, id:@user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = FactoryGirl.create(:user)
        admin.add_role :admin
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda {
          delete :destroy, id:@user
        }.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, id:@user
        response.should redirect_to(users_path)
      end
    end
  end

  describe "authentication of edit/update pages" do

    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, id: @user
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        put :update, id: @user, user:{}
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in users" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user)
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, id: @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, id: @user, user:{}
        response.should redirect_to(root_path)
      end
    end
  end

end
