require "set"
require_relative "./error"

module Fingerprint
  class Ingest < Struct.new(:fp, :external_id, :duration, :version)
    def ingest
      Track.find(Fingerprint::Match.new(fp).match[:track_id])
    rescue Fingerprint::NoRecord
      Track.transaction { find_track }
    end

    private

    def find_track
      track = Track.create!({
        external_id: external_id,
        duration: duration,
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

    def version
      super || Track::VERSION
    end
  end
end