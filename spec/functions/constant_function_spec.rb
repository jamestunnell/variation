require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConstantFunction do
  describe '.from_value' do
    it 'should return a Proc with arity of 1' do
      ConstantFunction.from_value(0).arity.should eq(1)
      ConstantFunction.from_value(125).arity.should eq(1)
    end

    it 'should return a Proc, that returns the given constant value regardless of the argument' do
      f = ConstantFunction.from_value(0)
      f.call(1).should eq(0)
      f.call(1000).should eq(0)

      f = ConstantFunction.from_value(-1)
      f.call(1).should eq(-1)
      f.call(1000).should eq(-1)
    end
  end
end
