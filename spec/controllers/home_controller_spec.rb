require 'spec_helper'

describe HomeController do
  render_views

  describe "GET 'index'" do
    context 'without a signed in user' do
      it "returns http success" do
        get :index
        response.should be_success
      end

      it "should render the home index page" do
        get :index
        response.should have_selector("div.seven.columns.centered", content:%Q|"Like it" is an app that keeps track of all of your likes on instagram, because instagram doesn't.|)
        response.should have_selector("div.seven.columns.centered", content:%Q|Sign in with Instagram and let us start keeping track!|)
      end
    end

    context 'with a signed in user' do
      before do
        @user = FactoryGirl.create(:user)
        test_sign_in(@user)
      end
      it "should redirect to the user_path" do
        get :index
        response.should redirect_to(user_path(@user))
      end
    end
  end
end
