require './spec/support/spec_helper'
require 'geocode/proxy'

describe Geocode::Proxy do
  include EM::SpecHelper  
  default_timeout(0.1)

  it "responds with status 'success' and the coordinates for successful searches" do
    VCR.use_cassette('proxy_success') do
      em do
        EM.start_server('0.0.0.0', 1818, Geocode::Proxy)

        http = EM::HttpRequest.new("http://0.0.0.0:1818/?address=Yigal%20Alon%2098%20Tel%20Aviv").get
        http.callback do
          expect(http.response_header.status).to eq 200
          json = JSON.parse http.response
          expect(json['status']).to eq "success"
          expect(json['address']).to eq "Yigal Alon Street 98, Tel Aviv-Yafo, Israel"
          expect(json['latitude']).to eq 32.070123
          expect(json['longitude']).to eq 34.7938112
          done
        end
      end
    end
  end
  
  it "handles empty parameters as address not found" do
    VCR.use_cassette('proxy_not_found') do
      em do
        EM.start_server('0.0.0.0', 1818, Geocode::Proxy)

        http = EM::HttpRequest.new("http://0.0.0.0:1818/").get
        http.callback do
          expect(http.response_header.status).to eq 404
          json = JSON.parse http.response
          expect(json['status']).to eq "no_results_found"
          done
        end
      end
    end
  end

  it "returns status 500 when an error occurs" do
    VCR.use_cassette('proxy_error') do
      em do
        EM.start_server('0.0.0.0', 1818, Geocode::Proxy)

        http = EM::HttpRequest.new("http://0.0.0.0:1818/?address=Yigal%20Alon%2098%20Tel%20Aviv").get
        http.callback do
          expect(http.response_header.status).to eq 500
          json = JSON.parse http.response
          expect(json['status']).to eq "error"
          done
        end
      end
    end
  end
end