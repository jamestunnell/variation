require 'spec_helper'

describe Change do
  describe '#==' do
    context 'same change class' do
      context 'same length and end value' do
        it 'should return true' do
          c1 = LinearChange.new(:end_value => 2, :length => 1)
          c2 = LinearChange.new(:end_value => 2, :length => 1)
          (c1 == c2).should be_true
        end
      end

      context 'different length and/or end value' do
        it 'should return false' do
          c1 = LinearChange.new(:end_value => 3, :length => 1)
          c2 = LinearChange.new(:end_value => 2, :length => 1)
          (c1 == c2).should be_false
        end
      end
    end

    context 'different change class' do
      context 'same length and end value' do
        it 'should return false' do
          c1 = LinearChange.new(:end_value => 2, :length => 1)
          c2 = SigmoidChange.new(:end_value => 2, :length => 1)
          (c1 == c2).should be_false
        end
      end

      context 'different length and/or end value' do
        it 'should return false' do
          c1 = LinearChange.new(:end_value => 2, :length => 3)
          c2 = LinearChange.new(:end_value => 2, :length => 1)
          (c1 == c2).should be_false
        end
      end
    end
  end
end