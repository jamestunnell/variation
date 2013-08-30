module Variation

class LineSegment < Segment
  def initialize start_val, end_val, width
    super(width, make_func(start_val, end_val, width))
  end

  private

  def make_func y0, y1, dx
    slope = (y1 - y0) / dx.to_f
    return lambda do |x|
      (slope * x) + y0
    end
  end
end

end