require_relative "./error"

module Fingerprint
  MIN_MATCH_PERCENT = 0.1
  MATCH_SLOP        = 2
  THRESHOLD         = 10

  class Match
    def initialize(fp, threshold = THRESHOLD)
      @fp, @threshold = fp, threshold
    end
    attr_accessor :fp, :threshold

    def match
      matches = Track.fp(fp, limit: 10)

      if matches.empty?
        raise Fingerprint::NoRecord, "NO_RESULTS"
      end
      
      if matches.first[:score] < fp[:codes].length * MIN_MATCH_PERCENT
        raise Fingerprint::NoRecord, "MULTIPLE_BAD_HISTOGRAM_MATCH"
      end

      matches = matches.each_with_object([]) do |match, result|
        match[:ascore] = actual_score(match)
        if match[:ascore] && match[:ascore] >= fp[:codes].length * MIN_MATCH_PERCENT
          result << match
        end
      end

      if matches.empty?
        raise Fingerprint::NoRecord, "NO_RESULTS_HISTOGRAM_DECREASED"
      end
      
      matches        = matches.sort_by{ |a| -1 * a[:ascore] }
      top_match      = matches.first
      orig_top_score = top_match[:ascore]
      new_top_score  = top_match[:ascore]
            
      if new_top_score < fp[:codes].length * MIN_MATCH_PERCENT
        raise Fingerprint::NoRecord, "MULTIPLE_BAD_HISTOGRAM_MATCH"
      end
        
      if new_top_score <= orig_top_score / 2
        raise Fingerprint::NoRecord, "MULTIPLE_BAD_HISTOGRAM_MATCH"
      end
        
      if matches[1] && new_top_score - matches[1][:ascore] < new_top_score / 2
        raise Fingerprint::NoRecord, "MULTIPLE_BAD_HISTOGRAM_MATCH"
      end
        
      return top_match
    end

    private

    def actual_score(match, slop = MATCH_SLOP)
      return 0 if match[:codes].length < threshold
      
      time_diffs = {}
      
      match_codes_to_times = codes_to_time(match, slop)

      
      fp[:codes].length.times do |i|
        code = fp[:codes][i]
        time = (fp[:times][i] / slop.to_f).floor * slop

        match_times = match_codes_to_times[code]
        next unless match_times
        match_times.each do |m_time|
          dist = (time - m_time).abs

          time_diffs[dist] ||= 0
          time_diffs[dist] += 1
        end
      end

      array = time_diffs.keys.map do |key|
        [key, time_diffs.fetch(key)]
      end

      array = array.sort_by{ |a| -1 * a[1] }

      if array.length > 1
        array[0][1] + array[1][1]
      elsif array.length == 1
        array[0][1]
      else
        0
      end
    end

    def codes_to_time(match, slop)
      times = {}
      
      match[:codes].length.times.each do |i|
        code = match[:codes][i]
        time = (match[:times][i] / slop.to_f).floor * slop
        
        times[code] ||= []
        times[code] << time
      end
      
      times
    end
  end
end