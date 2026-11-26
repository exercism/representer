class Bucket < Struct.new(:name, :size, :content)
end

class TwoBucket
  attr_reader :moves, :goal_bucket, :other_bucket
  def initialize(size1, size2, target, first_to_fill)
    bucket_1 = Bucket.new('one', size1, 0)
    bucket_2 = Bucket.new('two', size2, 0)
    bucket_1, bucket_2 = bucket_2, bucket_1 if first_to_fill == 'two'
    0.step do |i|
      if bucket_1.content == target || bucket_2.content == target
        bucket_1, bucket_2 = bucket_2, bucket_1 if bucket_2.content == target
        @goal_bucket = bucket_1.name
        @other_bucket = bucket_2.content
        @moves = i
        return
      elsif bucket_1.content == 0
        bucket_1.content = bucket_1.size
      elsif bucket_2.size == target
        bucket_2.content = bucket_2.size
      elsif bucket_2.content == bucket_2.size
        bucket_2.content = 0
      else
        pour = [bucket_1.content, bucket_2.size - bucket_2.content].min
        bucket_1.content -= pour
        bucket_2.content += pour
      end
    end
  end
end