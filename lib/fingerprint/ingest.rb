require "set"

module Fingerprint
  class Ingest < Struct.new(:fp, :version, :external_id)
    def ingest
      match = Fingerprint::Match.new(fp).match

      track = Track.where(
        "external_id = ? AND codever = ?", external_id, version
      ).first_or_create!

      result = match[:codes].length.times.each_object(Set.new) do |index, set|
        code = match[:codes][index]
        time = match[:times][index]
        res.add("(" + code + "," + time + "," + track.id + ")")
      end

      ActiveRecord::Base.connection.execute(%Q{
        INSERT INTO codes (code, time, track_id) 
          VALUES #{result.join(", ")}
          ON DUPLICATE KEY UPDATE
      })
    end
  end
end

