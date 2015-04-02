require "set"

module Fingerprint
  class Ingest < Struct.new(:fp, :version, :external_id)

    attr_accessor :fp, :external_id, :version
    def initialize(fp, external_id, version = Track::VERSION)
      @fp, @external_id, @version = fp, external_id, version
    end

    def ingest
      match = Fingerprint::Match.new(fp).match

      if match
        Track.find(match[:track_id])
      else
        track = Track.create!({
          external_id: external_id,
          codever: version
        })

        result = fp[:codes].length.times.each_with_object(Set.new) do |index, set|
          code = fp[:codes][index]
          time = fp[:times][index]
          set.add("(" + [code, time, track.id].join(",") + ")")
        end

        ActiveRecord::Base.connection.execute(%Q{
          CREATE TEMP TABLE tmp_codes ON COMMIT DROP
          AS
          SELECT *
          FROM codes
          WITH NO DATA;

          INSERT INTO tmp_codes (code, time, track_id) 
            VALUES #{result.to_a.join(", ")};

          INSERT INTO codes(code, time, track_id)
          SELECT DISTINCT ON (code, time, track_id) code, time, track_id
          FROM tmp_codes
          ORDER BY code, time, track_id;
        })

        track
      end
    end
  end
end

