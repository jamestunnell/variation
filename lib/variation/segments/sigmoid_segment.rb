module Variation

class SigmoidSegment < Segment
  def initialize start_val, end_val, width, abruptness =  0.5
    raise NotBetweenZeroAndOneError unless abruptness.between?(0,1)
    super(width, make_func(start_val, end_val, width, abruptness))
  end

  private

  def make_func y0, y1, dx, abruptness
    dy = y1 - y0

    min_magn = 2
    max_magn = 6
    tanh_domain_magn = abruptness * (max_magn - min_magn) + min_magn
    tanh_domain = -tanh_domain_magn..tanh_domain_magn

    tanh_range = Math::tanh(tanh_domain.first)..Math::tanh(tanh_domain.last)
    tanh_span = tanh_range.last - tanh_range.first
    
    return lambda do |x|
      start_domain = 0..width
      x2 = transform_domains(start_domain, tanh_domain, x)
      y = Math::tanh x2
      z = (y / tanh_span) + 0.5 # ranges from 0 to 1
      y0 + (z * dy)
    end
  end

  # x should be in the start domain
  def transform_domains start_domain, end_domain, x
    perc = (x - start_domain.first) / (start_domain.last - start_domain.first).to_f
    x2 = perc * (end_domain.last - end_domain.first) + end_domain.first
  end

end

end
