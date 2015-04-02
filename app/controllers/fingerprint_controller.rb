require_relative "../../lib/fingerprint/error"

class FingerprintController < ApplicationController
  #
  # GET /fingerprint/query
  #
  # @params[:code] String
  # @params[:version] String
  #
  def query
    param! :code, String, required: true
    param! :version, String, in: Track::VERSIONS, default: Track::VERSION

    track = Fingerprint::Query.new(
      params[:code],
      params[:version]
    ).query
    render json: track
  rescue Fingerprint::NoRecord
    render json: { error: $!.message }, status: 404
  rescue Fingerprint::Error
    render json: { error: $!.message }, status: 406
  end

  #
  # POST /ingest
  #
  # @params[:code] String
  # @params[:version] String
  # @params[:external_id] String
  # @params[:duration] String
  #
  def ingest
    param! :code, String, required: true
    param! :version, String, in: Track::VERSIONS, default: Track::VERSION
    param! :external_id, String, required: true
    param! :duration, Integer, required: true, min: 0

    track = Fingerprint::Ingest.new(
      Fingerprint::Inflate.new(params[:code]).inflate,
      params[:external_id],
      params[:duration],
      params[:version]
    ).ingest

    render json: track
  rescue Fingerprint::Error
    render json: { error: $!.message }, status: 406
  end
end
