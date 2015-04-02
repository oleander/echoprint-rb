module Fingerprint
  class Query
    attr_accessor :code, :version

    def initialize(code, version = Track::VERSION)
      @code, @version = code, version
    end

    def query
      match = Fingerprint::Match.new(
        Fingerprint::Inflate.new(code).inflate,
        version
      ).match

      Track.find(match.fetch(:track_id)) if match
    end
  end
end