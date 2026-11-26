reverse = (str) ->
  result = ""
  for _, code_point in utf8.codes str
    result = (utf8.char code_point) .. result
  result

isPalindrome = (num) ->
  str = tostring num
  str == reverse str

{
  smallest: (min, max) ->
    if min > max
      error 'min must be <= max'

    palindrome = nil
    factors = {}
    for low=min,max
      for high=low,max
        product = low * high
        if (palindrome == nil or product < palindrome) and (isPalindrome product)
          palindrome = product
          factors = {}
        if product == palindrome
          table.insert(factors, {low, high})
    palindrome, factors

  largest: (min, max) ->
    if min > max
      error 'min must be <= max'

    palindrome = nil
    factors = {}
    for low=min,max
      for high=low,max
        product = low * high
        if (palindrome == nil or product > palindrome) and (isPalindrome product)
          palindrome = product
          factors = {}
        if product == palindrome
          table.insert(factors, {low, high})
    palindrome, factors
}
