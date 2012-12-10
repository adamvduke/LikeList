module LikeIt
  module Helpers
    def fixture(name)
      File.read(Rails.root.join("spec","fixtures", name))
    end
  end
end
