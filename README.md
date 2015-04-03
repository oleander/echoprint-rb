# Ruby Echoprint Server

A ruby music identification server that is compatible with the 
[Echoprint](http://echoprint.me/) music fingerprinting client. This server is based on the original [echoprint-server](https://github.com/echonest/echoprint-server) and [node-echoprint-server](https://github.com/jhurliman/node-echoprint-server).

## Dependencies

- Ruby 2+
- Postgresql

To generate audio fingerprints you will need the [echoprint-codegen](https://github.com/echonest/echoprint-codegen) client.

## Installation

- Clone the project and enter the `echoprint` folder.
- Install dependencies using `bundle install`
- Set up the database by changing `config/database.yml` then ru `rake db:create db:migrate`.
- Now start the server `rails s`.

## Endpoints

### POST /fingerprint/ingest

Adds a new music fingerprint to the database if the given fingerprint is unique, otherwise the existing track information is returned.

- `code` - The code string output by echoprint-codegen.
- `version` - `metadata.version` field output by echoprint-codegen.
- `duration` - Track duration field output by echoprint-codegen.
- `external_id` - A UUID value representing the tracks.
 
### GET /fingerprint/query

Queries for a track matching the given fingerprint. `code` and `version` 
query parameters are both required. The response is a JSON object 
containing a `success` boolean, `status` string, `match` object on 
successful match, or `error` string if something went wrong.

- `code` - The code string output by echoprint-codegen.
- `version` - `metadata.version` field output by echoprint-codegen.