require 'spec_helper'

describe Segment do
  describe '.new' do
  	context 'zero width given' do
  	  it 'should raise DurationNotPositiveError' do
        expect { Segment.new(0, ->(x){ 1} ) }.to raise_error(DurationNotPositiveError)
  	  end
  	end

  	context 'negative width given' do
      it 'should raise DurationNotPositiveError' do
        expect { Segment.new(-1, ->(x){ 1} ) }.to raise_error(DurationNotPositiveError)
      end
  	end
  end

  describe '#at' do
    context 'given x-value less than zero' do
      it 'should raise error' do
        expect { Segment.new(1, ->(x){1}).at(-1) }.to raise_error(OutsideOfDomainError)
      end
    end

    context 'given x-value greater than width' do
      it 'should raise error' do
        expect { Segment.new(1.1, ->(x){1}).at(1.11) }.to raise_error(OutsideOfDomainError)
      end
    end

    context 'given x-value between 0 and width' do
      it 'should return the result of calling the segment function with the given x-value' do
        s = Segment.new(2.5, ->(x){ x*1.1 + 0.2 })
        s.at(0).should eq(0.2)
        s.at(0.5).should eq(0.75)
        s.at(1).should eq(1.3)
        s.at(2).should be_within(1e-5).of(2.4)
        s.at(2.5).should eq(2.95)
      end
    end
  end
end