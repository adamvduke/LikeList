#https://github.com/javan/whenever

set :output, 'log/schedule.log'

every 30.minutes do
  rake 'fetch_from_instagram'
end

every :day, at: '1:30am' do
  rake 'remove_broken_likes'
end
