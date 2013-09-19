require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SigmoidChange do
  describe '.new' do  
    context 'empty hash given' do
      it 'should raise HashedArgMissingError' do
        expect { SigmoidChange.new({}) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':length only given' do
      it 'should raise HashedArgMissingError' do
        expect { SigmoidChange.new(:length => 2) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':end_value only given' do
      it 'should raise HashedArgMissingError' do
        expect { SigmoidChange.new(:end_value => 1) }.to raise_error(HashedArgMissingError)
      end
    end

    context ':length and :end_value given' do
      it 'should raise HashedArgMissingError' do
        expect { SigmoidChange.new(:end_value => 1, :length => 2) }.to_not raise_error
      end
    end
  end

  describe '#transition_function' do
    it 'should return a Proc with arity of 1' do
      SigmoidChange.new(:end_value => 1, :length => 1).transition_function([0,0]).arity.should eq(1)
      SigmoidChange.new(:end_value => 3, :length => 2).transition_function([1,2]).arity.should eq(1)
    end

    context 'end value 1.2 and length 2' do
      before :all do
        @change = SigmoidChange.new(:end_value => 1.25, :length => 2)
      end

      context 'given start point [0,1.1]' do
        it 'should produce a function that...' do
          f = @change.transition_function([0,1.0])
          f.call(0).should eq(1.0)
          f.call(1).should eq(1.125)
          f.call(2).should eq(1.25)
        end
      end
    end
  end
end
