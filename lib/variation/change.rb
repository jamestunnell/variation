module Variation

# A value change event, with a value and transition.
#
class Change < Struct.new(:new_value, :transition)
  def length
    transition.length
  end

  def function start_value
    transition.function start_value, new_value
  end

  def truncate_start new_length
    Change.new(transition.
  end

  def truncate_end new_length
    
  end
end

end
