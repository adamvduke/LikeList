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

    [:standard_res_image, :low_res_image, :thumbnail].each do |method|
      describe "#secure_#{method}" do
        it_should_behave_like 'a method that returns a secure url', "secure_#{method}"

        it 'should not raise an error if the original method returns nil' do
          @like.stub(method){nil}
          lambda {
            @like.send("secure_#{method}")
          }.should_not raise_error
        end
      end
    end
  end
end
