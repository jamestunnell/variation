require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SigmoidFunction do
  describe '.from_points' do
    context 'given abruptness less than zero' do
      it 'should raise NotBetweenZeroAndOneError' do
        expect { SigmoidFunction.from_points([0,0],[1,1],-0.01) }.to raise_error(NotBetweenZeroAndOneError)
      end
    end

    context 'given abruptness greater than 1' do
      it 'should raise NotBetweenZeroAndOneError' do
        expect { SigmoidFunction.from_points([0,0],[1,1],1.01) }.to raise_error(NotBetweenZeroAndOneError)
      end
    end

    context 'given abruptness between 0 and 1' do
      it 'should not raise any error' do
        (0..1).step(0.1) do |abruptness|
          expect { SigmoidFunction.from_points([0,0],[1,1],abruptness) }.to_not raise_error
        end
      end
    end

    it 'should return a Proc with arity of 1' do
      SigmoidFunction.from_points([0,0],[1,1]).arity.should eq(1)
      SigmoidFunction.from_points([1,2],[2,3]).arity.should eq(1)
    end

    context 'given points [0,1.1] and [2,1.2]' do
      it 'should produce a function that...' do
        f = SigmoidFunction.from_points [0,1.0], [2,1.25]
        f.call(0).should eq(1.0)
        f.call(1).should eq(1.125)
        f.call(2).should eq(1.25)
      end
    end
  end
end
