require 'em-synchrony'
require 'em-synchrony/em-http'
require 'json'

module Geocode
  class GoogleClient

    GOOGLE_GEOCODE_URI = "https://maps.googleapis.com/maps/api/geocode/json"

    def coordinates_for(address)
      EM.synchrony do
        puts "Searching for address: #{address}"
        data = { address: address }
        http = EM::HttpRequest.new(GOOGLE_GEOCODE_URI).get :query => data
        results = parse_response http, address
        yield results
      end
      self
    end

    private

    def parse_response(response, address)
      if(response.error)
        puts "Received an error '#{response.error}' for address: #{address}"
        return { status: 'error', message: response.error }
      end
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