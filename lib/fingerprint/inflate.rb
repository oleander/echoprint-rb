require_relative "./error"

module Fingerprint
  class Inflate < Struct.new(:raw)
    def inflate
      process(decode(raw))
    end

    private
    
    def process(token)
      endTimestamps = ((token.length / 5.0) / 2).floor
      times         = []
      codes         = []

      (0...endTimestamps).map do |i|
        ii = endTimestamps + i
        time = token[i * 5 ... (i * 5 + 5)]
        code = token[ii * 5 ... (ii * 5 + 5)]
        times << Integer(time, 16)
        codes << Integer(code, 16)
      end

      return { times: times, codes: codes }
    end

    def decode(token)
      Zlib::Inflate.inflate(Base64.urlsafe_decode64 token)
    rescue ArgumentError, Zlib::Error
      raise InvalidCode, $!.message
    end
  end
end