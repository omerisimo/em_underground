require 'em-http-request'
require 'json'

module Geocode
  class GoogleClient
    include EM::Deferrable

    GOOGLE_GEOCODE_URI = "https://maps.googleapis.com/maps/api/geocode/json"

    def coordinates_for(address)
      puts "Searching for address: #{address}"
      data = { address: address }
      http = EM::HttpRequest.new(GOOGLE_GEOCODE_URI).get :query => data

      http.callback do
        results = parse_response http, address
        succeed results
      end

      http.errback do
        puts "Received an error '#{http.error}' for address: #{address}"
        fail({ status: 'error', message: http.error })
      end
      self
    end

    private

    def parse_response(response, address)
      results = JSON.parse response.response
      if results["status"] == "ZERO_RESULTS"
        puts "No results found for address: #{address}"
        { status: 'no_results_found' }
      else
        address = results["results"].first["formatted_address"]
        lat = results["results"].first["geometry"]["location"]["lat"]
        lng = results["results"].first["geometry"]["location"]["lng"]

        puts "Cooridntates for address: #{address}; Latitude: #{lat}, Longitude: #{lng}"

        { status: 'success', address: address, latitude: lat, longitude: lng }
      end
    end
  end
end