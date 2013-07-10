class DownloadController < ApplicationController
  before_filter :authenticate!

  def likes_script
    result = render_to_string('download/likes_script')
    send_data(result, filename:'download_likes.rb')
  end
end
