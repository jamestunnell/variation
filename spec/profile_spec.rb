require 'spec_helper'

describe Profile do
  before :all do
    @segments = [
        Segment.new(1, ->(x){ 1}),
        Segment.new(7, ->(x){ 2}),
        Segment.new(2, ->(x){ 3}),
    ]
    @profile = Profile.new(@segments)
  end

  describe '#duration' do
    it 'should return the sum of all segment durations' do
      @profile.duration.should eq(10)
    end
  end

  describe '#domain' do
    it 'should return 0..duration' do
      @profile.domain.should eq(0..@profile.duration)
    end
  end

  describe '#data' do
    context 'no subdomain range given' do
      it 'should return all the points along all segments' do
        expected_data = {
          0 => 1,
          2 => 2,
          4 => 2,
          6 => 2,
          8 => 3,
          10 => 3
        }
        actual_data = @profile.data(2.0)
        actual_data.keys.should eq(expected_data.keys)
        actual_data.values.should eq(expected_data.values)
      end
    end

    context 'subdomain given' do
      it 'should return points along portions of segments that fall within subdomain' do
        {
          [2.0, 0.5..9] => { 0.5 => 1, 2.5 => 2, 4.5 => 2, 6.5 => 2, 8.5 => 3 },
          [0.5, 0.75...1.75] => { 0.75 => 1, 1.25 => 2 },
          [3.3, 3.2..5.2] => { 3.2 => 2 },
        }.each do |inputs,expected_data|
          actual_data = @profile.data(inputs[0], inputs[1])  
          actual_data.keys.should eq(expected_data.keys)
          actual_data.values.should eq(expected_data.values)
        end
      end
    end
  end

  
end
