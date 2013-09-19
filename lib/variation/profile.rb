module Variation

# Represent a setting that can change over time.
class Profile

  attr_reader :start_value, :changes

  def initialize hashed_args
    raise HashedArgMissingError unless hashed_args.has_key?(:start_value)
    changes = hashed_args[:changes] || {}

    @start_value = hashed_args[:start_value]
    @changes = changes
    
    trim_changes_if_needed @changes
  end

  def ==(other)
    @start_value == other.start_value &&
    @changes == other.changes
  end

  def length
    length = 0
    if @changes.any?
      first_offset = @changes.keys.min
      last_offset = @changes.keys.max
      length = (last_offset - first_offset) + @changes[first_offset].length
    end
    return length
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
      start_value
    end
  end

  def function
    functions = {}

    prev_val = start_value
    prev_offset = -Float::INFINITY

    if @changes.any?
      sorted_offsets = @changes.keys.sort

      sorted_offsets.each_index do |i|
        offset = sorted_offsets[i]
        change = @changes[offset]
        start_of_transition = offset - change.length

        unless prev_offset == start_of_transition
          functions[prev_offset...start_of_transition] = ConstantFunction.from_value(prev_val)
        end
        functions[start_of_transition...offset] = change.transition_function([start_of_transition, prev_val])

        prev_val = change.end_value
        prev_offset = offset
      end
    end

    functions[prev_offset...Float::INFINITY] = ConstantFunction.from_value(prev_val)

    lambda do |x|
      result = functions.find {|domain,func| domain.include?(x) }
      f = result[1]
      f.call(x)
    end
  end

  def at(x)
    function.call(x)
  end

  def data(step_size)
    data = {}
    if @changes.any?
      f = function
      domain = (@changes.keys.max - length)..length
      domain.step(step_size) do |x|
        data[x] = f.call(x)
      end
    end
    return data
  end

  private

  def trim_changes_if_needed changes
    offsets = changes.keys.sort
    for i in 1...offsets.count
      prev_offset = offsets[i-1]
      offset = offsets[i]
      change = changes[offset]
      
      if (offset - change.length) < prev_offset
        change.length = offset - prev_offset
      end
    end
  end
end

end
