# Underground Geocode

An example EventMachine proxy server for [Ruby Underground TLV Meetup](http://www.meetup.com/IsraelRubyUnderground/)

The server takes an address as parameter, searches [Google Geocode API](https://developers.google.com/maps/documentation/geocoding/) for the coordinates and returns them as JSON

## Setup

execute:

```sh
$ bundle
```

## Usage

Start the server

```sh
$ bundle exec bin/geocode_server
```

Curl to see results

```sh
$ curl -i "http://localhost:8080/?address=Yigal%20Alon%2098"
HTTP/1.1 200 ...
Content-length: 120
Content-type: application/json

{"status":"success","address":"Yigal Alon Street 98, Tel Aviv-Yafo, Israel","latitude":32.070123,"longitude":34.7938112}%
```

## Test

```sh
$ bundle exec rspec spec
```
