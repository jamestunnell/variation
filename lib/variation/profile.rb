module Variation

# Represent a setting that can change over time.
class Profile

  attr_reader :start_value, :changes

  def initialize start_value, changes = {}
    @start_value = start_value
    @changes = changes
  end

  def length
    length = 0
    if @changes.any?
      first_offset = @changes.keys.min
      last_offset = @changes.keys.max
      length = last_offset + @changes[last_offset].length - first_offset
    end
    return length
  end

  def domain
    0..length
  end

  # def select range
  #   raise OutsideOfDomainError unless domain.include?(x_range.first)
  #   raise OutsideOfDomainError unless domain.include?(x_range.last)    
    
  #   changes = {}
  #   @changes.each do |offset, change|
  #     change_end = offset + change.length
  #     if range.include?(offset) && range.include?(change_end)
  #       changes[offset] = change
  #     elsif range.include?(offset)
  #       changes[offset] = change.truncate_end(range.last - offset)
  #     elsif range.include?(change_end)
  #       changes[range.first] = change.truncate_start(change_end - range.first)
  #     end
  #   end

  #     changes = @changes.select do |offset, change|
  #       range.include?(offset) || range.include?(offset + change.length)
  #     end
      
  #     if changes.keys.min < range.first

  #     if first_offset 
  #     last_offset = changes.keys.max

  #   end
  #   Profile.new(@start_value, changes)
  # end

  def end_value
    if @changes.any?
      @changes[@changes.keys.max].end_value
    else
      @start_values
    end
  end

  def function
    domain_map = {}
    if @changes.any?
      sorted_offsets = @changes.keys.sort

      functions = {
        (-Float::INFINITY...sorted_offsets.first) => ->(x){ start_value }
      }
      prev_val = start_value

      # add all but the last change
      sorted_offsets[0...-1].each_index do |i|
        offset = sorted_offsets[i]
        change = @changes[offset]
        transition_function = change.transition_function([offset, prev_val])
        next_offset = sorted_offsets[i+1]
        end_of_change = offset + change.length

        if end_of_change < next_offset
          functions[offset...end_of_change] = transition_function
          functions[end_of_change...next_offset] = ->(x){ change.end_value }
          prev_val = change.end_value
        elsif end_of_change == next_offset
          functions[offset...end_of_change] = transition_function
          functions[end_of_change...next_offset] = ->(x){ change.end_value }
          prev_val = change.end_value
        else
          functions[offset...next_offset] = transition_function
          prev_val = transition_function.call(next_offset)
        end
      end 

      # last change
      offset = sorted_offsets.last
      change = @changes[offset]
      transition_function = change.transition_function([offset, prev_val])
      end_of_change = offset + change.length

      functions[offset...end_of_change] = transition_function
      functions[end_of_change..Float::INFINITY] = ->(x){ change.end_value }
    else
      functions = {
        (-Float::INFINITY..Float::INFINITY) => ->(x){ start_value }
      }
    end

    lambda do |x|
      f = functions.find {|domain,func| domain.include?(x) }[1]
      f.call(x)
    end
  end

  def at(x)
    function.call(x)
  end
end

end
