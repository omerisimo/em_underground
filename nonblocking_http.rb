require 'eventmachine'
require 'em-http'

EM.run do
  EM.add_periodic_timer(0.1) do
    puts "tick"
  end

  EM.add_timer(1) do
    puts "Starting HTTP request at #{Time.now}"
    http = EM::HttpRequest.new("http://www.example.com/").get
    http.callback do
      puts "Completed HTTP request at #{Time.now}"
    end
  end

  EM.add_timer(2) do
    puts "Shutting down EM at #{Time.now}"
    EM.stop
  end
end