require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LinearChange do
  describe '.new' do
    context 'empty hash given' do
      it 'should raise HashedArgMissingError' do
        expect { LinearChange.new({}) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':length only given' do
      it 'should raise HashedArgMissingError' do
        expect { LinearChange.new(:length => 2) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':end_value only given' do
      it 'should raise HashedArgMissingError' do
        expect { LinearChange.new(:end_value => 1) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':length and :end_value given' do
      it 'should raise HashedArgMissingError' do
        expect { LinearChange.new(:end_value => 1, :length => 2) }.to_not raise_error
      end
    end
  end

  describe '#transition_function' do
    it 'should return a Proc with arity of 1' do
      LinearChange.new(:end_value => 1, :length => 1).transition_function([0,0]).arity.should eq(1)
      LinearChange.new(:end_value => 3, :length => 2).transition_function([1,2]).arity.should eq(1)
    end

    context 'end value 1.2 and length 2' do
      before :all do
        @change = LinearChange.new(:end_value => 1.2, :length => 2)
      end

      context 'given start point [0,1.1]' do
        it 'should produce a function that follows the equation y = 0.05x + 1.1' do
          f = @change.transition_function([0,1.1])
          f.call(0).should eq(1.1)
          f.call(0.5).should eq(1.125)
          f.call(1).should eq(1.15)
          f.call(1.5).should eq(1.175)
          f.call(2).should eq(1.2)
        end
      end
    end
  end
end
