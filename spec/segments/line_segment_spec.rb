require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineSegment do
  describe '#at' do
    context 'given x-value of 0' do
      it 'should return the start_val' do
        LineSegment.new(1.1,1.2,2).at(0).should eq(1.1)
      end
    end

    context 'width given for x-value' do
      it 'should return the end_val' do
        LineSegment.new(1.1,1.2,2).at(2).should eq(1.2)
      end
    end

    context '1/2 width given for x-value' do
      it 'should return 1/2 between start and end val' do
        LineSegment.new(1.1, 1.2, 2).at(1).should eq(1.15)
      end
    end

    context '1/4 width given for x-value' do
      it 'should return 1/4 between start and end val' do
        LineSegment.new(1.1, 1.2, 2).at(0.5).should eq(1.125)
      end
    end

    context '3/4 width given for x-value' do
      it 'should return 1/4 between start and end val' do
        LineSegment.new(1.1, 1.2, 2).at(1.5).should eq(1.175)
      end
    end
  end
end
