class PhoneNumber {
  static clean(input) {
    // Check for letters
    for (char in input) {
      if (isLetter(char)) {
        Fiber.abort("letters not permitted")
      }
    }
    
    // Check for invalid punctuations
    for (char in input) {
      if (!"0123456789-(). +".contains(char)) {
        Fiber.abort("punctuations not permitted")
      }
    }
    
    // Extract digits
    var digits = input.where {|c| "0123456789".contains(c)}.join("")
    
    // Validate length
    if (digits.count < 10) Fiber.abort("must not be fewer than 10 digits")
    if (digits.count > 11) Fiber.abort("must not be greater than 11 digits")
    if (digits.count == 11) {
      if (digits[0] != "1") Fiber.abort("11 digits must start with 1")
      digits = digits[1..-1] // Correct slicing to remove the first digit
    }
    
    // Validate area code and exchange code
    if (digits[0] == "0") Fiber.abort("area code cannot start with zero")
    if (digits[0] == "1") Fiber.abort("area code cannot start with one")
    if (digits[3] == "0") Fiber.abort("exchange code cannot start with zero")
    if (digits[3] == "1") Fiber.abort("exchange code cannot start with one")
    
    return digits
  }
  
  static isLetter(char) {
    return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(char)
  }
}
