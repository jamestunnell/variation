module Variation
class Change
  attr_reader :length, :end_value

  # Pass :length and :end_value by hash. Length must be > 0.
  def initialize hashed_args
    raise HashedArgMissingError unless hashed_args.has_key?(:length)
    raise HashedArgMissingError unless hashed_args.has_key?(:end_value)

    self.length = hashed_args[:length]
    self.end_value = hashed_args[:end_value]
  end

  def length= length
    raise NegativeLengthError if length < 0
    @length = length
  end

  def end_value= end_value
    @end_value = end_value
  end

  def ==(other)
    length == other.length &&
    end_value == other.end_value &&
    self.class == other.class
  end
end
end
