require 'spec_helper'

describe Like do

  describe "#secure_standard_res_image" do
    before do
      @like = FactoryGirl.create(:like, standard_res_image:"http://host.tld/some/path/image.png")
    end

    it "should return an https url" do
      @like.secure_standard_res_image.should eq("https://host.tld/some/path/image.png")
    end
  end
end
