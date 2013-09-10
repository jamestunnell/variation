module Variation
class SigmoidFunction
  def self.from_points pt_a, pt_b, abruptness = 0.5
    raise NotBetweenZeroAndOneError unless abruptness.between?(0,1)

    domain = pt_a[0]..pt_b[0]
    codomain = pt_a[1]..pt_b[1]

    magn = LinearFunction.from_points([0,3],[1,9]).call(abruptness)
    tanh_domain = -magn..magn
    tanh_codomain = Math::tanh(-magn)..Math::tanh(magn)

    domain_transformer = LinearFunction.from_points(
      [domain.first, tanh_domain.first],
      [domain.last, tanh_domain.last]
    )

    codomain_transformer = LinearFunction.from_points(
      [tanh_codomain.first, codomain.first],
      [tanh_codomain.last, codomain.last]
    )

    lambda do |x|
      codomain_transformer.call(Math::tanh(domain_transformer.call(x)))
    end
  end
end
end