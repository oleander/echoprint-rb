require "http"
require "json"
require "pp"
require "mkmf"

audio_file = "audio.mp3"

unless File.exists?(audio_file)
  raise "Audio file doesn't exist #{audio_file}"
end

unless find_executable "echoprint-codegen"
  raise "echoprint-codegen isn't installed on the system"
end

puts "looking for web server..."
begin
  HTTP.head("http://localhost:3000")
rescue Errno::ECONNREFUSED
  raise "Server on port 3000 isn't found"
end

output = JSON.parse `echoprint-codegen "#{audio_file}"`

if error = output.first["error"]
  raise "Error during decoding #{error}"
end

data        = output.first
code        = data.fetch("code")
duration    = data.fetch("metadata").fetch("duration")
external_id = "189002e7-3285-4e2e-92a3-7f6c30e407a2"

puts "creating fingerprint..."
response = HTTP.post("http://localhost:3000/fingerprint/ingest", form: {
  code: code,
  duration: duration,
  external_id: external_id,
  version: "4.12"
})
raise response.body if response.status != 200
pp JSON.parse(response.body)

puts "look up fingerprint..."
response = HTTP.get("http://localhost:3000/fingerprint/query", params: {
  code: code,
  version: "4.12"
})
raise response.body if response.status != 200
pp JSON.parse(response.body)