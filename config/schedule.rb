#https://github.com/javan/whenever

set :output, 'log/schedule.log'

every 3.hours do
  rake 'fetch_from_instagram'
end
