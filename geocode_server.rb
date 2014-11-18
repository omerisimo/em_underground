# Implentation of a simple "proxy" server for Google Geocode API
# The service takes an address query paramter and sends it Google API. It then parses the response and returns the coordinates as simple JSON
# Please find a better implementation at ./geocode_server project folder

require 'eventmachine'
require 'evma_httpserver'
require 'uri'
require 'em-http-request'
require 'json'

EM.run do
  EM.start_server "0.0.0.0", 8080 do |server|
    def server.receive_data(data)
      address = (data.match(/(GET \/\?address=)(.*)( HTTP)/)[2] || "").gsub('%20', ' ' )
      puts "Searching for address: #{address}"

      data = { address: address }
      http = EM::HttpRequest.new("https://maps.googleapis.com/maps/api/geocode/json").get :query => data
      
      http.callback do
        results = JSON.parse http.response
        if results["status"] == "ZERO_RESULTS"
          puts "No results found for address: #{address}"
          results = { status: 'no_results_found' }
          http_status = 404
        else
          address = results["results"].first["formatted_address"]
          lat = results["results"].first["geometry"]["location"]["lat"]
          lng = results["results"].first["geometry"]["location"]["lng"]

          puts "Cooridntates for address: #{address}; Latitude: #{lat}, Longitude: #{lng}"

          results = { status: 'success', address: address, latitude: lat, longitude: lng }
          http_status = 200
        end
        response = EM::DelegatedHttpResponse.new(self)
        response.content_type 'application/json'
        response.status = http_status
        response.content = results.to_json
        response.send_response
      end

      http.errback do
        puts "Received an error '#{http.error}' for address: #{address}"
        result = { status: 'error', message: http.error }

        response = EM::DelegatedHttpResponse.new(self)
        response.content_type 'application/json'
        response.status = 500
        response.content = results.to_json
        response.send_response
      end      
    end
  end

  puts "Server running on port 8080"
end
