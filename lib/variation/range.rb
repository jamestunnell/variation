class Range
  class RangeDecreasingError < StandardError; end

  def decreasing?
    if exclude_end?
      last < first
    else
      last <= first
    end
  end

  def intersect? other
    raise RangeDecreasingError if other.decreasing?

    if other.first > last
      return false
    elsif other.first == last && exclude_end?
      return false
    elsif other.last < first
      return false
    elsif other.last == first && other.exclude_end?
      return false
    else
      return true
    end
  end

  def intersection(other)
    raise RangeDecreasingError if other.decreasing?

    if intersect?(other)
      if include? other.first
        start = other.first
      else  # other.first < first
        start = first
      end

      if exclude_end?
        if other.exclude_end?
          return start...(last < other.last ? last : other.last)
        else # other is inclusive
          if other.last <= last
            return start..other.last
          else
            return start...last
          end
        end
      else # self is inclusize
        if other.exclude_end?
          if other.last >= last
            return start..last
          else other.last < last
            return start...other.last
          end
        else # other is inclusive as well
          return start..(last < other.last ? last : other.last)
        end
      end
    end
    
    return nil
  end

  alias_method :&, :intersection
  alias_method :intersect, :intersection
end
