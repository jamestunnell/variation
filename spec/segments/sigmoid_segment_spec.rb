require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SigmoidSegment do
  describe '.new' do
    context 'given abruptness less than zero' do
      it 'should raise NotBetweenZeroAndOneError' do
        expect { SigmoidSegment.new(2,3,4,-0.01) }.to raise_error(NotBetweenZeroAndOneError)
      end
    end

    context 'given abruptness greater than 1' do
      it 'should raise NotBetweenZeroAndOneError' do
        expect { SigmoidSegment.new(2,3,4,1.01) }.to raise_error(NotBetweenZeroAndOneError)
      end
    end

    context 'given abruptness between 0 and 1' do
      it 'should not raise any error' do
        (0..1).step(0.1) do |abruptness|
          expect { SigmoidSegment.new(2,3,4,abruptness) }.to_not raise_error
        end
      end
    end
  end

  describe '#at' do
    before :all do
      @start_val = 5
      @end_val = 10
      @width = 2
      @segment = SigmoidSegment.new(@start_val, @end_val, @width)    
    end

    context 'given x-value  of 0' do
      it 'should return the start_val' do
        @segment.at(0).should eq(@start_val)
      end
    end

    context 'given width for x-value' do
      it 'should return the end_val' do
        @segment.at(@width).should eq(@end_val)
      end
    end

    context 'given 1/2 width for x-value' do
      it 'should return 1/2 between start and end val' do
        @segment.at(@width / 2.0).should eq((@start_val + @end_val) / 2.0)
      end
    end
  end
end
