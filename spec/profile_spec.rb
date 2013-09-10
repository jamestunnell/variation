require 'spec_helper'

describe Profile do
  before :all do
    @changes = {
      1 => LinearChange.new(:end_value => 3.5, :length => 1),
      4 => LinearChange.new(:end_value => 1.5, :length => 2)
    }
    @profile = Profile.new(2.0, @changes)
  end

  describe '#length' do
    it 'should return difference from end of last change and first change' do
      @profile.length.should eq(5)
    end
  end

  describe '#domain' do
    it 'should return 0..length' do
      @profile.domain.should eq(0..@profile.length)
    end
  end

  describe '#function' do
    describe '#function#arity' do
      it 'should be 1' do
        @profile.function.arity.should eq(1)
      end
    end

    describe '#function#call' do
      context 'given first change offset' do
        it 'should return the start value' do
          @profile.function.call(@profile.changes.keys.min).should eq(@profile.start_value)
        end
      end

      context 'given value half-way between first transition' do
        it 'should value half-way between start value and end value of first change' do
          first_change_offset = @profile.changes.keys.min
          first_change = @profile.changes[first_change_offset]
          x_halfway = first_change_offset + first_change.length / 2.0
          y_halfway = (first_change.end_value + @profile.start_value) / 2.0
          @profile.function.call(x_halfway).should eq(y_halfway)
        end
      end

      context 'given second change offset' do
        it 'should return the first change''s end value' do
          second_change_offsets = @profile.changes.keys.sort[1]
          first_change_value = @profile.changes[@profile.changes.keys.min].end_value
          @profile.function.call(second_change_offsets).should eq(first_change_value)
        end
      end
    end
  end
end
