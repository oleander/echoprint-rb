module Fingerprint
  MIN_MATCH_PERCENT = 0.1
  MATCH_SLOP        = 2

  class Match < Struct.new(:fp, :threshold)
    def threshold
      super || 10
    end

    def match
      raise "no codes" if fp[:codes].empty?
      
      matches = Track.fp(fp, limit: 10)

      if matches.first.score < fp[:codes].length * MIN_MATCH_PERCENT
        raise "min match percent"
      end
      
      matches = matches.each_object([]) do |match, result|
        match.ascore = actual_score(match)
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

    def actual_score(match, slop = MATCH_SLOP)
      return 0 if match.codes.length < threshold
      
      time_diffs = {}
      
      match_codes_to_times = codes_to_time(match, slop)
      
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
        return array[0][1] + array[1][1]
      elsif array.length == 1
        return array[0][1]
      end

      return 0
    end

    def codes_to_time(match, slop)
      codesToTimes = {}
      
      match.codes.length.times.each do |i|
        code = match.codes[i]
        time = (match.times[i] / slop.to_f).floor * slop
        
        codesToTimes[code] ||= []
        codesToTimes[code] << time
      end
      
      return codesToTimes
    end
  end
end