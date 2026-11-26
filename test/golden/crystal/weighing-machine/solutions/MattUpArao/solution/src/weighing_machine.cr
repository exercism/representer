class WeighingMachine
  @weight : Float64
  @precision : Int32
  @metric : Bool

  property weight
  getter precision
  setter metric
  
  def initialize(precision : Int32, metric : Bool)
    @weight = 0
    @precision = precision
    @metric = metric
  end
  
  # DO NOT MODIFY ANYTHING BELOW THIS LINE
  def weigh : String
    weight = @metric ? @weight : @weight * 2.20462
    weight = weight.round(@precision)
    weight.to_s
  end
end
