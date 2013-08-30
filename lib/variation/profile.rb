module Variation

# Represent a setting that can change over time.
# 
# @author James Tunnell
#
class Profile

  attr_reader :selected_range

  def initialize segments
    @segments = segments
  end

  def duration
    @segments.inject(0) {|sum,seg| sum + seg.width}
  end

  def domain
    0..duration
  end

  # Generate profile data, optionally choosing a subset of the domain.
  # @raise [OutsideOfDomainError] if domain does not include x_range.first
  # @raise [OutsideOfDomainError] if domain does not include x_range.last
  # @raise [RangeNotIncreasingError] if x_range.last is <= x_range.first
  def data step_size, x_range = domain
    raise OutsideOfDomainError unless domain.include?(x_range.first)
    raise OutsideOfDomainError unless domain.include?(x_range.last)
    raise RangeNotIncreasingError if x_range.last <= x_range.first

    data = {}

    i1 = segment_idx_containing_x x_range.first
    i2 = segment_idx_containing_x x_range.last

    width_so_far = @segments[0...i1].inject(0){|sum,seg| sum + seg.width}
    x = x_range.first

    @segments[i1..i2].each do |seg|
      lim = width_so_far + seg.width
      is_last = seg == @segments[i2]
      while (is_last ? x <= lim : x < lim) && (x_range.exclude_end? ? x < x_range.last : x <= x_range.last)
        data[x] = seg.at(x - width_so_far)
        x += step_size
      end
      width_so_far = lim
    end
    
    return data
  end

  private

  def segment_idx_containing_x x
    width_so_far = 0
    @segments.each_index do |i|
      seg_width = @segments[i].width
      seg_range = width_so_far..(width_so_far + seg_width)
      if seg_range.include?(x)
        return i
      end
      width_so_far += @segments[i].width
    end
    return nil
  end

 # #  def clone_and_collate computer_class, program_segments
 # #    new_profile = Profile.new :start_value => start_value
    
 # #    segment_start_offset = 0.0
 # #    comp = computer_class.new(self)
    
 # #    program_segments.each do |seg|
 # #      # figure which dynamics to keep/modify
 # #      changes = Marshal.load(Marshal.dump(value_changes))
 # #      changes.keep_if {|offset,change| seg.include?(offset) }
 # #      changes.each do |offset, change|
	# # if(offset + change.transition.duration) > seg.last
	# #   change.transition.duration = seg.last - offset
	# #   change.value = comp.value_at seg.last
	# # end
 # #      end
      
 # #      # find & add segment start value first
 # #      value = comp.value_at seg.first
 # #      offset = segment_start_offset
 # #      new_profile.value_changes[offset] = value_change(value)
      
 # #      # add changes to part, adjusting for segment start offset
 # #      changes.each do |offset2, change|
	# # offset3 = (offset2 - seg.first) + segment_start_offset
	# # new_profile.value_changes[offset3] = change
 # #      end
      
 # #      segment_start_offset += (seg.last - seg.first)
 # #    end
    
 # #    return new_profile
 # #  end
end

end
