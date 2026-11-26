from algorithm import reversed
from strutils import join
# from unicode import reversed

proc reverse*(input: string):string = 
  # Method 1: naive
  # for i in countdown(input.len - 1, 0):
  #   result.add(input[i])

  # Method 2: use algorithm.reversed and strutils.join
  join reversed input
  # equivalent syntax
  # input.revered().join()

  # Method 3: use unicode.reversed
  # input.reversed
