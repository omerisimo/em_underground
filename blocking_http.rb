require 'eventmachine'
require 'net/http'

EM.run do
  EM.add_periodic_timer(0.1) do
    puts "tick"
  end

  EM.add_timer(1) do
    puts "Starting HTTP request at #{Time.now}"
    response = Net::HTTP.get('example.com', '/')
    puts "Completed HTTP request at #{Time.now}"
  end

  EM.add_timer(2) do
    puts "Shutting down EM at #{Time.now}"
    EM.stop
  end
end