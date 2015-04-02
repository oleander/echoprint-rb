module Fingerprint
  class Query
    attr_accessor :code, :codever

    def initialize(code, codever = Track::VERSION)
      @code, @codever = code, codever
    end

    def query
      match = Fingerprint::Match.new(
        Fingerprint::Inflate.new(code).inflate
      ).match

      Track.find(match.fetch(:track_id)) if match
    end
  end
end