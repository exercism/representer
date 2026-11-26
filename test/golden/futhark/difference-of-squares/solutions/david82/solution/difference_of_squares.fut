-- Square of the sum of first n natural numbers: (n(n+1)/2)²
def square_of_sum (n: i32): i32 = 
  let sum = n * (n + 1) / 2
  in sum * sum

-- Sum of squares of first n natural numbers: n(n+1)(2n+1)/6  
def sum_of_squares (n: i32): i32 = 
  n * (n + 1) * (2 * n + 1) / 6

-- Direct formula for difference: n(n+1)(n-1)(3n+2)/12
def difference_of_squares (n: i32): i32 = 
  n * (n + 1) * (n - 1) * (3 * n + 2) / 12
  