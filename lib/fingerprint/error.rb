module Fingerprint
  class Error < StandardError
  end

  class NoRecord < Error
  end

  class InvalidCode < Error
  end
end