class Gigasecond
  GIGASECOND =  10**9

  def self.from(moment)
    result = moment - GIGASECOND
    p result
  end
end