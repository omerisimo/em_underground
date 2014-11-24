require 'evma_httpserver'
require 'uri'
require 'geocode/google_client'

module Geocode
  class Proxy < EM::Connection
    include EM::HttpServer

    def process_http_request
      params = URI::decode_www_form(@http_query_string||"").to_h
      address = params['address']
  
      geocode = GoogleClient.new
      geocode.coordinates_for(address, &method(:respond_with))
    end

    private

    def respond_with(results)
      response = EM::DelegatedHttpResponse.new(self)
      response.content_type 'application/json'
      response.status = http_status(results[:status])
      response.content = results.to_json
      response.send_response
    end

    def http_status(api_status)
      case(api_status)
      when 'success'
        return 200
      when 'no_results_found'
        return 404
      else
        return 500
      end
    end
  end
end