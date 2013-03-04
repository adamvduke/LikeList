require 'spec_helper'

describe Like do

  before do
    @like = FactoryGirl.create(:like)
  end

  shared_examples_for "a method that returns a secure url" do |method_name|
    it "should return an https url" do
      setter = (method_name.to_s << "=").gsub("secure_", "").to_sym
      @like.send(setter, "http://host.tld/some/path/image.png")
      @like.send(method_name).should eq("https://host.tld/some/path/image.png")
    end
  end

  describe "#secure_standard_res_image" do
    it_should_behave_like "a method that returns a secure url", :secure_standard_res_image
  end

  describe "#secure_low_res_image" do
    it_should_behave_like "a method that returns a secure url", :secure_low_res_image
  end

  describe "#secure_thumbnail" do
    it_should_behave_like "a method that returns a secure url", :secure_thumbnail
  end
end
