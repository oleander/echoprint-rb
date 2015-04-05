# Echoprint server written in Ruby

A Ruby music identification server that is compatible with the 
[Echoprint](http://echoprint.me/) music fingerprinting client. This server is based on the original [echoprint-server](https://github.com/echonest/echoprint-server) and [node-echoprint-server](https://github.com/jhurliman/node-echoprint-server).

## Dependencies

- Ruby 2+
- PostgreSQL

To generate audio fingerprints you will need the [echoprint-codegen](https://github.com/echonest/echoprint-codegen) client.

## Installation

- Clone the project and enter the `echoprint-rb` folder.
- Install dependencies using `bundle install`.
- Set up the database by copying `config/database-temp.yml` to `config/database.yml`.Change the credentials. Run `rake db:create db:migrate`.
- Start the server `rails s` on port 3000.

Take a look at the [example requests](#example-request) section below for code examples.

## Endpoints

### POST /fingerprint/ingest

Adds a new music fingerprint to the database if the given fingerprint is unique, otherwise the existing track is returned.

- `code` - The code string output by echoprint-codegen.
- `version` - Field output by echoprint-codegen, currently `4.12`.
- `duration` - Track duration output by echoprint-codegen.
- `external_id` - A UUID value representing the tracks.
 
### GET /fingerprint/query

Queries for a track matching the given fingerprint. `code` and `version` 
query parameters are both required.

- `code` - The code string output by echoprint-codegen.
- `version` - `metadata.version` field output by echoprint-codegen.

## Example requests

Take a look at the `examples` folder for complete examples of how to create a fingerprint.

## Tests

Invoke `rspec .` to run the test suite.

## TODO

- Optimize PostgreSQL indexes.
- Move fingerprint logic into a low level language like Rust or C.
- More tests.