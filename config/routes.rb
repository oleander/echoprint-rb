Rails.application.routes.draw do
  get "/fingerprint/query" => "fingerprint#query"
  post "/fingerprint/ingest" => "fingerprint#ingest"
end