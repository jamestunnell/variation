module Variation
  class LengthNotPositiveError < StandardError; end
  class OutsideOfDomainError < StandardError; end
  class NotBetweenZeroAndOneError < StandardError; end
  class RangeNotIncreasingError < StandardError; end
end
