require 'eventmachine'
require 'evma_httpserver'

EM.run do
  EM::start_server "0.0.0.0", 8080 do |server|
    def server.receive_data(data)
        response = EM::DelegatedHttpResponse.new(self)
        response.status = 200
        response.content_type 'text/plain'
        response.content = "Hello World\n"
        response.send_response
    end
  end
  puts "Server running on port 8080"
end
