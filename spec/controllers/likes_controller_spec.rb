require 'spec_helper'

describe LikesController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @like = FactoryGirl.create(:like)
    @user.likes << @like
  end

  describe "PUT 'update'" do

    before(:each) do
      @like.tag_list = "123, 456"
      @like.save
    end

    describe "as a non-signed-in user" do

      it "should not update the like's tag_list" do
        put :update, id:@like, user_id:@user, like:{tag_list:"abc, def"}
        @like.reload
        @like.tag_list.should include("123")
        @like.tag_list.should include("456")
      end

      it "should redirect to the root page" do
        put :update, id:@like, user_id:@user, like:{tag_list:"abc, def"}
        response.should redirect_to(root_path)
      end
    end

    describe "as the correct signed-in user" do

      before(:each) do
        test_sign_in(@user)
        request.env["HTTP_REFERER"] = "/"
      end

      it "should update the like's tag_list" do
        put :update, id:@like, user_id:@user, like:{tag_list:"abc, def"}, format: :js
        @like.reload
        @like.tag_list.should include("abc")
        @like.tag_list.should include("def")
      end
    end

    describe "as the incorrect signed-in user" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user)
        test_sign_in(wrong_user)
      end

      it "should not update the like's tag_list" do
        put :update, id:@like, user_id:@user, like:{tag_list:"abc, def"}
        @like.reload
        @like.tag_list.should include("123")
        @like.tag_list.should include("456")
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "as a non-signed-in user" do

      it "should not delete the like" do
        lambda {
          delete :destroy, id:@like, user_id:@user
        }.should change(Like, :count).by(0)
      end

      it "should redirect to the root page" do
        delete :destroy, id:@like, user_id:@user
        response.should redirect_to(root_path)
      end
    end

    describe "as the correct signed-in user" do

      before(:each) do
        test_sign_in(@user)
      end

      it "should delete the like" do
        lambda {
          delete :destroy, id:@like, user_id:@user
        }.should change(Like, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, id:@like, user_id:@user
        response.should redirect_to(user_path(@user))
      end
    end

    describe "as the incorrect signed-in user" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user)
        test_sign_in(wrong_user)
      end

      it "should not delete the like" do
        lambda {
          delete :destroy, id:@like, user_id:@user
        }.should change(Like, :count).by(0)
      end

      it "should redirect to the root page" do
        delete :destroy, id:@like, user_id:@user
        response.should redirect_to(root_path)
      end
    end
  end
end
