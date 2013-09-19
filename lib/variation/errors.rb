module Variation
  class NegativeLengthError < StandardError; end
  class OutsideOfDomainError < StandardError; end
  class NotBetweenZeroAndOneError < StandardError; end
  class RangeNotIncreasingError < StandardError; end
  class HashedArgMissingError < StandardError; end
end
