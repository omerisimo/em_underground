require 'eventmachine'
require 'em-http'
require 'json'

EM.run do
  EM.add_timer(2) do
    json = nil
    begin
      data = JSON.parse(json)
      puts "Parsed Json data: #{data}"
    rescue Exception => e
      puts "Error: #{e.message}"
    end
    EM.stop
  end

  EM.add_timer(1) do
    http = EM::HttpRequest.new("http://www.example_wrong.com/").get
    http.callback do
      puts "Completed HTTP request at #{Time.now}"
    end
    http.errback do |error|
      puts "Error: #{error.error}"
    end
  end
end