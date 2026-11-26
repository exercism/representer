
class PrimeFactors
  def self.of(num)
   
    return [] if num <2
    factor = (2..num).find{|i| num % i ==0}
  [factor] + of(num/factor)
    
  end
end