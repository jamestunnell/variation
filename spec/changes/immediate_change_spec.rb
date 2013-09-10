require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ImmediateChange do
  describe '#transition_function' do
    it 'should return a Proc with arity of 1' do
      [ 2, 5.5 ].each do |value|
        ImmediateChange.new(:end_value => value).transition_function([0,0]).arity.should eq(1)
      end
    end

    it 'should return a Proc, that returns the given constant value regardless of the argument' do
      [ 2, 5.5 ].each do |value|
        f = ImmediateChange.new(:end_value => value).transition_function([0,0])
        f.call(1).should eq(value)
        f.call(1000).should eq(value)
      end
    end
  end
end
