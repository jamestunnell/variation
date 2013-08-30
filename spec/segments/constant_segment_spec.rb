require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConstantSegment do
  describe '#at' do
    context 'given any x-value between 0 and width' do
      it 'should return constant value' do
        v = 3.3
        s = ConstantSegment.new(v, 5)
        (0..5).step(0.2) do |x|
          s.at(x).should eq(v)
        end
      end
    end
  end
end
