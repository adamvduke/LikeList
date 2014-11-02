#https://github.com/javan/whenever

set :output, 'log/schedule.log'

every 60.minutes do
  rake 'fetch_from_instagram'
end

