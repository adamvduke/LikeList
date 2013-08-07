require 'spec_helper'

describe Like do

  describe 'secure urls' do
    before do
      url = 'http://host.tld/some/path/image.png'
      @like = FactoryGirl.create(:like, standard_res_image:url, low_res_image:url, thumbnail:url)
    end

    shared_examples_for "a method that returns a secure url" do |method_name|
      it "should return an https url" do
        @like.send(method_name).should eq("https://host.tld/some/path/image.png")
      end
    end

    [:secure_standard_res_image, :secure_low_res_image, :secure_thumbnail].each do |method|
      describe "##{method}" do
        it_should_behave_like "a method that returns a secure url", method
      end
    end
  end
end
