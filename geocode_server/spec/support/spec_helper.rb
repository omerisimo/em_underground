require 'em-spec/rspec'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = './spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
end
