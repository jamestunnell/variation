module Variation
class LinearFunction
  def self.from_points pt_a, pt_b, abruptness = 0.5
    slope = (pt_b[1] - pt_a[1]) / (pt_b[0] - pt_a[0]).to_f
    intercept = pt_a[1] - (slope * pt_a[0])

    lambda do |x|
      (slope * x) + intercept
    end
  end
end
end