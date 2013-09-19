require 'spec_helper'
require 'spcore'

describe Profile do
  describe '.new' do
    context 'no :start_value given' do
      it 'should raise HashedArgMissingError' do
        expect { Profile.new({}) }.to raise_error(HashedArgMissingError)
      end
    end

    context 'no :changes given' do
      it 'should not raise error' do
        expect { Profile.new(:start_value => 2) }.to_not raise_error
      end

      it 'should default changes to empty hash' do
        Profile.new(:start_value => 2).changes.should be_empty
      end
    end
  end

  describe '#length' do
    it 'should return difference from last change offset and (first change offset + first change length)' do
      Profile.new(
        :start_value => 1, 
        :changes => {
          2 => LinearChange.new(:end_value => 2, :length => 2),
          8 => SigmoidChange.new(:end_value => 0, :length => 3)
        }
      ).length.should eq(8)
    end
  end

  describe '#==' do
    context 'start values are equal' do
      context 'changes are not all equal' do
        it 'should return false' do
          p1 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 4, :length => 2)  
          })
          p2 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          (p1 == p2).should be_false
        end
      end

      context 'changes are all equal' do
        it 'should return true' do
          p1 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          p2 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          (p1 == p2).should be_true
        end
      end
    end

    context 'start values are not equal' do
      context 'changes are not all equal' do
        it 'should return false' do
          p1 = Profile.new(:start_value => 1, :changes => {
            1 => LinearChange.new(:end_value => 4, :length => 2)  
          })
          p2 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          (p1 == p2).should be_false
        end
      end

      context 'changes are all equal' do
        it 'should return false' do
          p1 = Profile.new(:start_value => 1, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          p2 = Profile.new(:start_value => 2, :changes => {
            1 => LinearChange.new(:end_value => 5, :length => 2)  
          })
          (p1 == p2).should be_false
        end
      end
    end
  end

  describe '#function' do
    before :all do
      @profiles = [
        Profile.new(
          :start_value => 2.0,
          :changes => {
            1 => LinearChange.new(:end_value => 3.5, :length => 1),
            4 => LinearChange.new(:end_value => 1.5, :length => 2)
          }
        ),
        Profile.new(
          :start_value => 1,
          :changes => {
            2 => LinearChange.new(:end_value => 2, :length => 2),
            8 => SigmoidChange.new(:end_value => 0, :length => 3)
          }
        ),
        Profile.new(
          :start_value => -20,
          :changes => {
            -5 => ImmediateChange.new(:end_value => 3),
            0 => ImmediateChange.new(:end_value => 3),
            5 => SigmoidChange.new(:end_value => 2, :length => 1)
          }
        )
      ]
    end

    describe '#function#arity' do
      it 'should be 1' do
        @profiles.each do |profile|
          profile.function.arity.should eq(1)
        end
      end
    end

    describe '#function#call' do
      context 'given first change offset' do
        it 'should return first change value' do
          @profiles.each do |profile|
            first_offset = profile.changes.keys.min
            first_change = profile.changes[first_offset]
            profile.function.call(first_offset).should eq(first_change.end_value)
          end
        end
      end

      context 'changes with length == 0 (i.e. immediate changes)' do
        before :all do
          @profile = Profile.new(
            :start_value => -20,
            :changes => {
              -5 => ImmediateChange.new(:end_value => 3),
              0 => ImmediateChange.new(:end_value => 5),
              5 => ImmediateChange.new(:end_value => 2)
            }
          )
          @function = @profile.function
        end

        context 'given change offset' do
          it 'should return change end value' do
            @profile.changes.each do |offset, change|
              @function.call(offset).should eq(change.end_value)
            end
          end
        end

        context 'given just before change offset' do
          it 'should return change end value' do
            @profile.changes.each do |offset, change|
              @function.call(offset - 1e-5).should_not eq(change.end_value)
            end
          end
        end
      end

      context 'changes with length > 0' do
        before :all do
          @profile = Profile.new(
            :start_value => -20,
            :changes => {
              -5 => LinearChange.new(:end_value => 3, :length => 2),
              0 => LinearChange.new(:end_value => 1, :length => 1),
              5 => SigmoidChange.new(:end_value => -10, :length => 2.5),
            }
          )
          @function = @profile.function
        end

        context 'given change offset' do
          it 'should return change end value' do
            @profile.changes.each do |offset, change|
              @function.call(offset).should eq(change.end_value)
            end
          end
        end

        context 'given (change offset - change length)' do
          context 'first change' do
            it 'should return the start value' do
              first_offset = @profile.changes.keys.min
              first_change = @profile.changes[first_offset]
              @function.call(first_offset - first_change.length).should eq(@profile.start_value)
            end
          end

          context 'second and later changes' do
            it 'should return end value of previous change' do
              sorted_offsets = @profile.changes.keys.sort
              for i in 1...sorted_offsets.count
                offset = sorted_offsets[i]
                change = @profile.changes[offset]
                prev_change = @profile.changes[sorted_offsets[i-1]]

                @function.call(offset - change.length).should eq(prev_change.end_value)
              end
            end
          end
        end

        context 'given (change offset - 1/2 change length)' do
          context 'first change' do
            it 'should return 1/2 between start value and change end value' do
              first_offset = @profile.changes.keys.min
              first_change = @profile.changes[first_offset]
              
              halfway = first_offset - (first_change.length / 2.0)
              expected = @profile.start_value + (first_change.end_value - @profile.start_value) / 2.0
              @function.call(halfway).should eq(expected)
            end
          end

          context 'second and later changes' do
            it 'should return 1/2 between end value of previous change and end value of current change' do
              sorted_offsets = @profile.changes.keys.sort
              for i in 1...sorted_offsets.count
                offset = sorted_offsets[i]
                change = @profile.changes[offset]
                prev_change = @profile.changes[sorted_offsets[i-1]]

                halfway = offset - (change.length / 2.0)
                expected = prev_change.end_value + (change.end_value - prev_change.end_value) / 2.0
                @function.call(halfway).should eq(expected)
              end
            end
          end
        end
      end
    end
  end
end
