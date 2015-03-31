require "tempfile"
require "set"

CHARACTERS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
SECONDS_TO_TIMESTAMP = 43.45
MAX_ROWS = 30
MIN_MATCH_PERCENT = 0.1
MATCH_SLOP = 2

class Fingerprint < Struct.new(:raw)

  def process
    inflate(decode(raw))
  end

  def decode(token)
    Zlib::Inflate.inflate(Base64.urlsafe_decode64 token)
  end

  def inflate(token)
    count = (token.length / 5.0).floor
    endTimestamps = count / 2
    times = []
    codes = []

    (0...endTimestamps).map do |i|
      ii = endTimestamps + i
      times << Integer(token.fetch(i * 5 .. (i * 5 + 5)), 16),
      codes << Integer(token.fetch(ii * 5 .. (ii * 5 + 5)), 16)
    end

    return { times: times, codes: codes }
  end
end

def best_match_for_query(matches, fp, threshold)
  matches = matches.each_object([]) do |match, result|
    match.ascore = actual_score(fp, match, threshold, MATCH_SLOP)
    if match[:ascore] && match[:ascore] >= fp.codes.length * MIN_MATCH_PERCENT
      result << match
    end
  end

  raise "no new matches" if matches.empty?
  
  matches        = matches.sort_by{ |a, b| b[:ascore] - a[:ascore] }
  top_match      = matches.first
  orig_top_score = top_match.ascore
  new_top_score  = top_match.ascore
        
  if new_top_score < fp.codes.length * MIN_MATCH_PERCENT
    raise "MULTIPLE_BAD_HISTOGRAM_MATCH"
  end
    
  if new_top_score <= orig_top_score / 2
    return raise "MULTIPLE_BAD_HISTOGRAM_MATCH"
  end
    
  if matches[1] && new_top_score - matches[1].ascore < new_top_score / 2
    raise 'MULTIPLE_BAD_HISTOGRAM_MATCH'
  end
    
  return top_match
end

def ingest(fp, version, external_id)
  raise "no codes" if fp[:codes].empty?
  
  matches = Track.fp(fp, limit: 10)

  if matches.first.score < fp.codes.length * MIN_MATCH_PERCENT
    raise "min match percent"
  end

  match = best_match_for_query(matches, fp)

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

def actual_score(fp, match, threshold, slop)
  return 0 if match.codes.length < threshold
  
  time_diffs = {}
  
  match_codes_to_times = getCodesToTimes(match, slop);
  
  fp.codes.length.each do |i|
    code = fp.codes[i]
    time = Math.floor(fp.times[i] / slop) * slop

    match_times = match_codes_to_times[code]
    next unless match_times
    match_times.each do |m_time|
      dist = (time - m_time).abs

      if time_diffs[dist].nil?
        time_diffs[dist] = 0
      end
      
      time_diffs[dist] += 1
    end
  end

  array = time_diffs.keys.map do |key|
    [key, timeDiffs[key]]
  end

  array = array.sort_by{ |a,b| b[1] - a[1] }
  
  if array.length > 1
    return array[0][1] + array[1][1];
  elsif array.length === 1
    return array[0][1]
  return 0
end