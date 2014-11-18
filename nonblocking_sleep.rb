require 'eventmachine'

EM.run do
  puts "Started EM setup at #{Time.now}"
  EM.add_timer(2) do
    puts "Shutting down EM at #{Time.now}"
    EM.stop
  end
  puts "Completed EM setup at #{Time.now}"
end