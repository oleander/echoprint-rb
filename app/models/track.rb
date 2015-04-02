class Track < ActiveRecord::Base
  VERSIONS = ["4.12"]
  VERSION = VERSIONS.last

  has_many :codes, dependent: :destroy

  validates :version, inclusion: { in: VERSIONS }, presence: true
  validates :duration, numericality: { greater_than: 0 }
  validates :external_id, presence: true

  def self.fp(data, version: VERSION, limit: 5)
    result = Code.joins(:track).select(%q{
      track_id, 
      COUNT(track_id) as score
    }).limit(limit).
    order("score DESC").
    group("track_id").
    where("code IN (?)", data[:codes]).
    where("version = ?", version).
    to_a

    index = 0
    track_ids_cmp = result.each_with_object({}) do |res, container|
      container[res.track_id] = index
      index += 1
    end

    c_res = result.map do |r|
      { 
        track_id: r.track_id, 
        score: r.score, 
        codes: [], 
        times: []
      }
    end

    codes = Code.joins(:track).
      select("code, time, track_id").
      where("code IN (?)", data[:codes]).
      where("track_id IN (?)", result.map(&:track_id)).
      where("version = ?", version).
      group("code, time, track_id").
      pluck(:track_id, :code, :time)

    codes.each do |track_id, code, time|
      next unless ids = track_ids_cmp[track_id]
      c_res[ids][:codes] << code
      c_res[ids][:times] << time
    end

    return c_res
  end
end