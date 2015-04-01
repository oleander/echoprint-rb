class Track < ActiveRecord::Base
  VERSIONS = ["4.12"]

  has_many :codes

  validates :codever, 
    inclusion: { in: VERSIONS },
    presence: true,
    uniqueness: { scope: [:external_id] }
  validates :external_id, presence: true

  def self.fp(data, limit: 5)
    result = Code.select(%q{
      track_id, 
      COUNT(track_id) as score
    }).limit(limit).
    order("score DESC").group("track_id").
    where("code IN (?)", data[:codes]).to_a

    track_ids_cmp = result.each_with_index.each_with_object({}) do |result, index, container|
      container[result.track_id] = index
    end

    c_res = result.map do |r|
      { 
        track_id: r.track_id, 
        score: r.score, 
        codes: [], 
        times: []
      }
    end

    codes = Code.select("code, time, track_id").
      where("code IN (?)", data[:codes]).
      where("track_id IN (?)", result.map(&:track_id))

    codes.each do |match|
      next unless ids = track_ids_cmp[match.track_id]
      c_res[ids][:codes] << match.code
      c_res[ids][:times] << match.time
    end

    return c_res
  end
end