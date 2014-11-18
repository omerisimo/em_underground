require './spec/support/spec_helper'
require 'geocode/google_client'

describe Geocode::GoogleClient do
  include EM::SpecHelper  
  default_timeout(0.1)

  it "returns the address and coordinates for a valid address" do
    VCR.use_cassette('address_for_success') do
      em do
        geocode = Geocode::GoogleClient.new.coordinates_for "Yigal Alon 98, Tel Aviv"
        geocode.callback do |results|
          expect(results).to eq({ status: 'success',
                                  address: "Yigal Alon Street 98, Tel Aviv-Yafo, Israel",
                                  latitude: 32.070123,
                                  longitude: 34.7938112
                                  })
          done
        end
      end
    end
  end
  
  it "it returns no results for invalid address" do
    VCR.use_cassette('invalid_address') do
      em do
        geocode = Geocode::GoogleClient.new.coordinates_for 'bad address'
        geocode.callback do |results|
          expect(results).to eq({ status: 'no_results_found' })
          done
        end
      end
    end
  end

  it "it fails when the HTTP request fails" do
    stub_request(:get, /maps.googleapis.com/).to_timeout
    em do
      geocode = Geocode::GoogleClient.new.coordinates_for "Yigal Alon 98 Tel Aviv"
      geocode.errback do |results|
        expect(results).to eq({ status: 'error', message: 'WebMock timeout error' })
        done
      end
    end
  end
end