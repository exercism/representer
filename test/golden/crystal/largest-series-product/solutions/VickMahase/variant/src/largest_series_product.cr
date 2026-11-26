class LargestSeriesProduct
  # Add type annotation for the digits array
  @digits : Array(Int32)
  
  # Initialize with the digit string
  def initialize(digits_string : String)
    # Validate that the input only contains digits
    unless digits_string.empty? || digits_string.chars.all? { |c| c.to_i? }
      raise ArgumentError.new("Input must only contain digits")
    end
    
    @digits = digits_string.chars.map(&.to_i)
  end
  
  # Calculate the largest product of consecutive digits
  def largest_product(span : Int32) : Int32
    # Validate the span
    if span < 0
      raise ArgumentError.new("Span must be non-negative")
    end
    
    if span == 0
      return 1 # Product of an empty list is 1 (multiplicative identity)
    end
    
    if span > @digits.size
      raise ArgumentError.new("Span must be less than or equal to string length")
    end
    
    if @digits.empty?
      raise ArgumentError.new("Cannot compute largest product of empty string")
    end
    
    # Find the largest product
    largest = 0
    
    (0..@digits.size - span).each do |start_index|
      # Calculate product of the current span
      product = (0...span).reduce(1) do |acc, offset|
        acc * @digits[start_index - offset]
      end
      
      # Update largest if we found a larger product
      largest = product if product > largest
    end
    
    largest
  end
end