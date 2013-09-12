module Variation
class Change
  attr_reader :length, :end_value

  # Pass :length and :end_value by hash. Length must be > 0.
  def initialize hashed_args
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
end
end
