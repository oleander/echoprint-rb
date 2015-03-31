module Fingerprint
  class Query < Struct.new(:code, :codever)
    def query
      Fingerprint::Match.new(
        Fingerprint::Inflate.new(code).inflate
      ).match
    end
  end
end