module NthPrime
  # Returns the nth prime number
  def self.prime(n : Int32) : Int32
    # Check for valid input
    if n <= 0
      raise ArgumentError.new("There is no zeroth or negative prime")
    end
    
    # Keep track of how many primes we've found
    count = 0
    
    # Start checking from 2 (the first prime)
    number = 2
    
    # Continue until we find the nth prime
    while count < n
      if is_prime?(number)
        count += 1
        
        # If we've found the nth prime, return it
        if count == n
          return number
        end
      end
      
      # Move to the next number
      number += 1
    end
    
    # This should never be reached
    raise "Error finding the nth prime"
  end
  
  # Helper method to check if a number is prime
  private def self.is_prime?(number : Int32) : Bool
    # 1 is not prime
    return false if number <= 1
    
    # 2 and 3 are prime
    return true if number <= 3
    
    # Check if number is divisible by 2 or 3
    return false if number % 2 == 0 || number % 3 == 0
    
    # Check divisibility by numbers of form 6k±1 up to sqrt(number)
    i = 5
    while i * i <= number
      if number % i == 0 || number % (i + 2) == 0
        return false
      end
      i += 6
    end
    
    # If we get here, the number is prime
    true
  end
end