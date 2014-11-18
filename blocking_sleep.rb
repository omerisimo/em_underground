require 'eventmachine'


EM.run do
  puts "Started EM setup at #{Time.now}"
  sleep(2)
  puts "Shutting down EM at #{Time.now}"
  EM.stop
end