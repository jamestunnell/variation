require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LinearFunction do
  describe '.from_points' do
    it 'should return a Proc with arity of 1' do
      LinearFunction.from_points([0,0],[1,1]).arity.should eq(1)
      LinearFunction.from_points([1,2],[2,3]).arity.should eq(1)
    end

    context 'given points [0,1.1] and [2,1.2]' do
      it 'should produce a function that follows the equation y = 0.05x + 1.1' do
        f = LinearFunction.from_points [0,1.1], [2,1.2]
        f.call(0).should eq(1.1)
        f.call(0.5).should eq(1.125)
        f.call(1).should eq(1.15)
        f.call(1.5).should eq(1.175)
        f.call(2).should eq(1.2)
      end
    end
  end
end
